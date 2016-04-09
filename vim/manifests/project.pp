class vim::project::config {
    file { '/root/.vimrc-dev':
        ensure  => file,
        replace => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        source  => 'puppet:///modules/vim/.vimrc-dev'
    }
}

class vim::project inherits vim {
    #require vim    
    include vim::project::config
}
