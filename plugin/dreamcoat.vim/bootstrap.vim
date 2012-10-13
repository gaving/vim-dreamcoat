if !exists('g:DREAMCOAT_INSTALL_PATH')
  let g:DREAMCOAT_INSTALL_PATH = fnamemodify(expand("<sfile>"), ":p:h")
end

if !exists('g:DREAMCOAT_SCHEME_REGISTRY')
  let g:DREAMCOAT_SCHEME_REGISTRY = "http://localhost:3000/schemes"
end

:command! -nargs=1 DreamcoatLoad :call dreamcoat#Load(<q-args>)
:command! DreamcoatRandom :call dreamcoat#Random()

:call dreamcoat#Dreamcoat()
