{
  imports = [
    ./bash
  ];

  environment = {
    variables = {
      HISTSIZE = "-1";
      HISTFILESIZE = "-1";
    };
  };
}
