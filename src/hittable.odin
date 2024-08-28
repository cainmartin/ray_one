package main

HitRecord :: struct {
	point:      Point3,
	normal:     Vec3,
	t:          f64,
	front_face: bool,
}

set_face_normal :: proc(hit: ^HitRecord, ray: Ray, outward_normal: Vec3) {
	hit.front_face = vec3_dot(ray.dir, outward_normal) < 0
	hit.normal = hit.front_face ? outward_normal : -outward_normal
}

// The interface / trait that represents a hittable object
Hittable :: struct {
	data: rawptr,
	hit:  proc(data: rawptr, ray: Ray, t_min: f64, t_max: f64, hit_record: ^HitRecord) -> bool,
}

// Container to hold list of objects that conform to the Hittable type
HittableList :: struct {
	objects: [dynamic]Hittable,
}

// Method to add 
hit :: proc(list: ^HittableList, ray: Ray, t_min: f64, t_max: f64, rec: ^HitRecord) -> bool {

	temp_rec: HitRecord
	hit_anything := false
	closest_so_far := t_max

	for object in list.objects {
		if object.hit(object.data, ray, t_min, closest_so_far, &temp_rec) {
			hit_anything = true
			closest_so_far = temp_rec.t
			rec^ = temp_rec
		}
	}

	return hit_anything
}
