S = 40
x1 = 0; y1 = 0
x2 = rand(3..20); y2 = rand(3..20)
x3 = rand(10..20); y3 = 0
petal_count = rand(3..8)
TELOMERES_LOOP = 60
TELOMERES_PEAK = TELOMERES_LOOP / 2.0
now_loop = 0
FULL_BLOOM_LOOP = 20
full_bloom_loop = 0
index_cx = ((S * 2 + 1) / 2.0).floor
index_cy = ((S + 1) / 2.0).floor
frame = 0

loop do
  petal_points = []
  s = (0...(S+1)).map { (" " * S * 2) + " " }

  if now_loop.zero?
    x2 = rand(3..20)
    y2 = rand(3..20)
    x3 = rand(10..20)
  end

  # 花びらを描画する
  petal_count.times do |petal_i|
    degree = 360 / petal_count * petal_i + (now_loop + full_bloom_loop) * 5;
    radian = Math::PI / 180 * degree

    if now_loop < TELOMERES_PEAK
      y2_changed = (y2 / TELOMERES_PEAK) * now_loop
      x2_changed = (x2 / TELOMERES_PEAK) * now_loop
      x3_changed = (x3 / TELOMERES_PEAK) * now_loop
    else
      y2_changed = y2 - ((y2 / TELOMERES_PEAK) * (now_loop - TELOMERES_PEAK))
      x2_changed = x2 - ((x2 / TELOMERES_PEAK) * (now_loop - TELOMERES_PEAK))
      x3_changed = x3 - ((x3 / TELOMERES_PEAK) * (now_loop - TELOMERES_PEAK))
    end

    # 2本の2次ベジェ曲線を構成する点の座標を求めてpetal_pointsに保持する
    a_points = []
    b_points = []
    (0..40).each do |div|
      t = (0.025 * div)
      xa = (((1-t)**2)*x1) + (2*(1-t)*t*x2_changed) + ((t**2)*x3_changed)
      ya = (((1-t)**2)*y1) + (2*(1-t)*t*y2_changed) + ((t**2)*y3)
      xa2 = xa * Math.cos(radian) - ya * Math.sin(radian)
      ya2 = xa * Math.sin(radian) + ya * Math.cos(radian)
      a_points << [xa2, ya2]

      xb = (((1-t)**2)*x1) + (2*(1-t)*t*x2_changed) + ((t**2)*x3_changed)
      yb = (((1-t)**2)*y1) + (2*(1-t)*t*(y2_changed * -1)) + ((t**2)*y3)
      xb2 = xb * Math.cos(radian) - yb * Math.sin(radian)
      yb2 = xb * Math.sin(radian) + yb * Math.cos(radian)
      b_points << [xb2, yb2]
    end
    petal_points << a_points
    petal_points << b_points
  end

  # 座標の点を元に、マーチングスクエア法でいい感じの描画文字を決めていく
  petal_points.each do |points|
    points.each.with_index do |p, i|
      el_number_y = (p[1]).floor + index_cy
      el_number_x = (p[0] * 2).floor + index_cx
      if !(el_number_y > (s.length - 1)) && !(el_number_x > s[0].length - 1)
        if i == 0
          s[el_number_y][el_number_x] = "*"
        else
          dy = (p[1] - points[i-1][1])
          dx = (p[0] - points[i-1][0])
          mark = "|" if dx.zero?
          scope = dy / dx

          dec = ((p[1].round(1) - p[1].floor) * 10).to_i
          mark ||= case dec
                    when 0..2 then (dy.zero? ? '^' : '`')
                    when 3..7 then nil
                    else (dy.zero? ? '_' : ',')
                    end

          mark ||= case scope.round(1)
            when 0.0 .. 0.9 then '*'
            when 1.0 .. 1.9 then '\\'
            else ';'
            end
          s[el_number_y][el_number_x] = mark
        end
      end
    end
  end

  # 描く
  print "\e[2J"
  print "\e[1;1H" + s.join("\n")

  # フレーム数のカウントアップとリセット
  frame += 1
  if now_loop > TELOMERES_PEAK && full_bloom_loop < FULL_BLOOM_LOOP
    full_bloom_loop += 1
  else
    now_loop += 1
  end
  if now_loop > TELOMERES_LOOP
    now_loop = 0
    full_bloom_loop = 0
  end

  sleep 0.03
end

