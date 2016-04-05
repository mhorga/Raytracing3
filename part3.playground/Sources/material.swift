
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
        attenuation = albedo
        return true
    }
}

class metal: material {
    var albedo: float3
    var fuzz: Float
    
    init(a: float3, f: Float) {
        albedo = a
        if f < 1 {
            fuzz = f
        } else {
            fuzz = 1
        }
    }
    
    func scatter(ray_in: ray, _ rec: hit_record, inout _ attenuation: float3, inout _ scattered: ray) -> Bool {
        let reflected = reflect(normalize(ray_in.direction), n: rec.normal)
        scattered = ray(origin: rec.p, direction: reflected + fuzz * random_in_unit_sphere())
        attenuation = albedo
        return dot(scattered.direction, rec.normal) > 0
    }
}
