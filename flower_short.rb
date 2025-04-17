S = 40;
L = 60;
P = L / 2.0;
CX = ((S * 2 + 1) / 2).floor;
CY = ((S + 1) / 2).floor;
f = 0;
k = 0;

loop()do;
  pps = [];
  s = (0...(S+1)).map { ("\s" * S * 2) + "\s" };

  (f.zero?)&&(
    $x2 = rand(3..20);
    $y2 = rand(3..20);
    $x3 = rand(10..20);
    $pn = ARGV[0]&.to_i || rand(3..8);
    $cl = (31..37).to_a.sample.to_s;
  );

  $pn.times { |p|
    r = Math::PI / 180 * ( 360 / $pn * p + (f + k) * 5 );
    cr = Math.cos(r);
    sr = Math.sin(r);

    d = f < P;
    y2c = (d)?($y2/P*f):($y2-$y2/P*(f-P));
    x2c = (d)?($x2/P*f):($x2-$x2/P*(f-P));
    x3c = (d)?($x3/P*f):($x3-$x3/P*(f-P));

    a = [];
    b = [];
    (0..40).each { |div|
      t = 0.025 * div;
      x = (2*(1-t)*t*x2c) + ((t**2)*x3c);
      ya = (2*(1-t)*t*y2c);
      a << [x * cr - ya * sr, x * sr + ya * cr];

      yb = (2*(1-t)*t*(y2c * -1));
      b << [x * cr - yb * sr, x * sr + yb * cr];
    };
    pps << a;
    pps << b;
  };

  pps.each { |ps|
    ps.each.with_index { |p, i|
      ey = (p[1]).floor + CY;
      ex = (p[0] * 2).floor + CX;
      if( !(ey > (s.length - 1)) && !(ex > s[0].length - 1) ) then;
        if ( i == 0) then;
          s[ey][ex] = "*";
        else;
          dy = (p[1] - ps[i-1][1]);
          dx = (p[0] - ps[i-1][0]);
          (dx.zero?) && (m = "!");
          dec = ((p[1].round(1) - p[1].floor) * 10).to_i;
          m ||= ("```TRICK2025"[dec]) || ",";
          (m =~ /\w/)&&(m = "*;"[(dy/dx).round] || 'l');
          s[ey][ex] = m;
        end;
      end;
    };
  };

  print "\e[2J";
  print "\e[" + $cl + "m";
  print "\e[1;1H" + s.join("\n");

  (f > P && k < 20)?(k+=1):(f+=1);
  (f > L)&&(f=0;k=0;);

  sleep(0.03);
end;
