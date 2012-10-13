if has('ruby')
  if !exists('g:DREAMCOAT_DIRECTORY')
    if has('win32') || has('win64')
      let g:DREAMCOAT_DIRECTORY = $TEMP
    else
      let g:DREAMCOAT_DIRECTORY = '/tmp'
    end
  endif

  ruby $: << File.join(Vim.evaluate('g:DREAMCOAT_INSTALL_PATH'), 'lib')
  ruby require 'dreamcoat'
  ruby Dreamcoat.load_dependencies!
  ruby Dreamcoat.load_schemes!
  ruby Dreamcoat.refresh_schemes!

  function! dreamcoat#Dreamcoat()
  endfunction

function! dreamcoat#Random()
  ruby <<RANDOM!
    Dreamcoat.random!()
RANDOM!
endfunction
function! dreamcoat#Load(scheme)
  ruby <<LOAD!
    Dreamcoat.load!(Vim.evaluate('a:scheme'))
LOAD!
endfunction
else
  function! dreamcoat#Dreamcoat()
    echo "Sorry, dreamcoat.vim requires vim to be built with Ruby support."
  endfunction
end
