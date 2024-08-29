package main

import "core:fmt"
import "core:strings"

Color :: Vec3

write_color :: proc(builder: ^strings.Builder, color: Color) {
	intensity := interval_new(0.000, 0.999)
	rbyte := int(256 * interval_clamp(intensity, color.r))
	gbyte := int(256 * interval_clamp(intensity, color.g))
	bbyte := int(256 * interval_clamp(intensity, color.b))

	fmt.sbprintf(builder, "%d %d %d\n", rbyte, gbyte, bbyte)
}
