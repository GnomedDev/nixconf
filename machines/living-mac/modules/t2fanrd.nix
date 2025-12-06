{ ... }:
{
  services.t2fanrd = {
    enable = true;
    config.Fan1 = {
      low_temp = 50;
      high_temp = 100;
      speed_curve = "linear";
      always_full_speed = false;
    };
  };
}
