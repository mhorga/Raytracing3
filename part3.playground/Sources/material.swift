
import simd

protocol material {
    func scatter(ray_in: ray, _ rec: hit_record, inout _ attenuation: float3, inout _ scattered: ray) -> Bool
}

class lambertian: material {
    var albedo: float3
    
    init(a: float3) {
        albedo = a
    }
    
    func scatter(ray_in: ray, _ rec: hit_record, inout _ attenuation: float3, inout _ scattered: ray) -> Bool {
        let target = rec.p + rec.normal + random_in_unit_sphere()
        scattered = ray(origin: rec.p, direction: target - rec.p)
        attenuation = float3(0.5, 0.5, 0.5) // albedo
        return true
    }
}

class metal: material {
    var albedo: float3
    
    init(a: float3) {
        albedo = a
    }
    
    func scatter(ray_in: ray, _ rec: hit_record, inout _ attenuation: float3, inout _ scattered: ray) -> Bool {
        let reflected = reflect(normalize(ray_in.direction), n: rec.normal)
        scattered = ray(origin: rec.p, direction: reflected)
        attenuation = float3(0.5, 0.5, 0.5) // albedo
        return dot(scattered.direction, rec.normal) > 0
    }
}

//func reflect(v: float3, _ n: float3) -> float3 {
//    return v - 2 * dot(v, n) * n
//}
