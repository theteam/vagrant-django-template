class python {
  $packages = ["build-essential", "python", "python-dev", "python-setuptools"]
  package { 
    $packages: ensure => installed;
  }
}