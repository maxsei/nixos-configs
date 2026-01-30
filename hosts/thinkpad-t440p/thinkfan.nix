{ lib, ... }:
{
  services.thinkfan.enable = true;

  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
  '';

  boot.kernelModules = lib.mkAfter [ "thinkpad_acpi" ];
}
