class version_control {
    include version_control::git
    include version_control::subversion
    include version_control::mercurial
    include version_control::bazaar
}
