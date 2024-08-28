package main

HitRecord :: struct {
    point : Point3,
    normal : Vec3,
    t : f64,
    front_face: bool,
}

set_face_normal :: proc (hit: ^HitRecord, ray: Ray, outward_normal: Vec3) {
    hit.front_face = vec3_dot(ray.dir, outward_normal) < 0
    hit.normal = hit.front_face ? outward_normal : -outward_normal
}

Hittable :: struct {
    data: rawptr,
    hit: proc(data: rawptr, ray: Ray, t_min: f64, t_max: f64, hit_record: ^HitRecord) -> bool
}
