FROM nnurphy/ub

ENV JULIA_HOME=/opt/julia
ENV PATH=${JULIA_HOME}/bin:$PATH
RUN set -eux \
  ; mkdir -p ${JULIA_HOME} \
  ; julia_version=$(curl -sSL https://julialang.org/downloads/ | pup '#current_stable_release > a text{}' | awk '{print $4}') \
  ; julia_version_n=$(echo $julia_version | node -e "console.log(fs.readFileSync('/dev/stdin', 'utf8').slice(1))") \
  ; julia_version_m=$(echo $julia_version_n | node -e "console.log(fs.readFileSync('/dev/stdin', 'utf8').split('.').slice(0,2).join('.'))") \
  ; curl https://julialang-s3.julialang.org/bin/linux/x64/${julia_version_m}/julia-${julia_version_n}-linux-x86_64.tar.gz \
    | tar xz -C ${JULIA_HOME} --strip-components 1 \
  ; julia -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer"); Pkg.add("StaticLint")'

RUN set -eux \
  ; nvim -u /etc/skel/.config/nvim/init.vim --headless +"CocInstall -sync coc-julia" +qa \
  #; npm config set registry https://registry.npm.taobao.org \
  ; npm cache clean -f
