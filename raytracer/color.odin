package main

import "core:fmt"
import "core:math"
import "core:strings"

Color :: Vec3

linear_to_gamma :: proc(linear_component: f64) -> f64 {
	if linear_component > 0 {
		return math.sqrt(linear_component)
	}

	return 0
}

write_color :: proc(builder: ^strings.Builder, color: Color) {
	intensity := interval_new(0.000, 0.999)

	r := linear_to_gamma(color.r)
	g := linear_to_gamma(color.g)
	b := linear_to_gamma(color.b)

	rbyte := int(256 * interval_clamp(intensity, r))
	gbyte := int(256 * interval_clamp(intensity, g))
	bbyte := int(256 * interval_clamp(intensity, b))

	fmt.sbprintf(builder, "%d %d %d\n", rbyte, gbyte, bbyte)
}

color_random :: proc() -> Color {
	return {random_f64_range(0, 1), random_f64_range(0, 1), random_f64_range(0, 1)}
}

color_random_range :: proc(min: f64, max: f64) -> Color {
	return {random_f64_range(min, max), random_f64_range(min, max), random_f64_range(min, max)}
}
