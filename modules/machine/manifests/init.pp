class machine {

    # Test to see if this is a vagrant 
    # machine or a non-local-virtual setup.

    if ( 'vagrant' in $hostname ) {
        $server_type = 'vagrant'
    } else {
        $server_type = 'server'
    }

}
