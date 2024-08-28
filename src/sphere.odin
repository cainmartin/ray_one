package main

import "core:math"

Sphere :: struct {
    center: Vec3,
    radius: f64,
}

sphere_new :: proc(center: Vec3, radius: f64) -> Sphere {
    return Sphere{ center, math.max(0, radius) }
}

sphere_hit :: proc(data: rawptr, ray: Ray, t_min: f64, t_max: f64, hit_record: ^HitRecord) -> bool {
    sphere := cast(^Sphere)data
    oc := sphere.center - ray.orig
    a :=  vec3_length_squared(ray.dir)
    h := vec3_dot(ray.dir, oc)
    c := vec3_length_squared(oc) - sphere.radius * sphere.radius

    discriminant := h * h - a * c
    if discriminant < 0 { return false }

    sqrtd := math.sqrt(discriminant)

    // Find the nearest root that lies within the acceptable range
    root := (h - sqrtd) / a
    if root <= t_min || t_max <= root {
        root = (h + sqrtd) / a
        if root <= t_min || t_max <= root {
            return false
        }
    }

    hit_record.t = root
    hit_record.point = ray_at(ray, hit_record.t)
    outward_normal := (hit_record.point - sphere.center) / sphere.radius
    set_face_normal(hit_record, ray, outward_normal)

    return true
}