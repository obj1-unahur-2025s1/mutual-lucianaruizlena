class Actividad {
  const property idiomas = #{}

  method implicaEsfuerzo() 
  method sirveParaBroncearse() = false
  method dias()
  method esInteresante() = idiomas.size() > 5
  method esRecomendadaPara(unSocio)
}

class ViajeAPlaya inherits Actividad {
  const largo

  override method dias() = largo / 500
  override method implicaEsfuerzo() = largo > 1200
  override method sirveParaBroncearse() = true

  override method esRecomendadaPara(unSocio) = self.esInteresante() && unSocio.leAtrae(self) && not unSocio.actividades().contains(self)
}

class ExcursionACiudad inherits Actividad {
  const property cantidadDeAtracciones

  override method esInteresante() = super() || cantidadDeAtracciones == 5
  override method dias() = cantidadDeAtracciones / 2
  override method implicaEsfuerzo() = cantidadDeAtracciones.between(5, 8)
}

class ExcursionACiudadTropical inherits ExcursionACiudad {
  override method dias() = super() + 1
  override method sirveParaBroncearse() = true
}

class SalidaDeTrekking inherits Actividad {
  const property kilometrosDeSenderoARecorrer
  const property diasDeSolPorAño

  override method esInteresante() = super() || kilometrosDeSenderoARecorrer == 5 && diasDeSolPorAño > 140
  override method dias() = kilometrosDeSenderoARecorrer / 50
  override method implicaEsfuerzo() = kilometrosDeSenderoARecorrer > 80
  override method sirveParaBroncearse() = diasDeSolPorAño > 200 || (diasDeSolPorAño.between(100, 200) && kilometrosDeSenderoARecorrer > 120)
}

class ClaseDeGimnasia inherits Actividad {
  method initialize() {
    idiomas.clear()
    idiomas.add("español")    
  }

  override method dias() = 1
  override method implicaEsfuerzo() = true
  override method esRecomendadaPara(unSocio) = unSocio.edad().between(20, 30)

}

class Socio {
  const property actividades = []
  const maximoActividades
  var property edad
  const property idiomasQueHabla = #{}
  
  method registrarActividad(unaActividad){
    if(maximoActividades == actividades.size()){
      self.error("el socio alcanzó el máximo de actividades")
    }
    actividades.add(unaActividad)
  }
  method esAdoradorDelSol() = actividades.all({a => a.sirveParaBroncearse()})
  method actividadesForzadas() = actividades.filter({a => a.implicaEsfuerzo()})

  method leAtrae(unaActividad)
}

class SocioTranquilo inherits Socio {
  override method leAtrae(unaActividad) = unaActividad.dias() >= 4
}

class SocioCoherente inherits Socio {
  override method leAtrae(unaActividad){
    return if (self.esAdoradorDelSol()){unaActividad.sirveParaBroncearse()} 
    else {unaActividad.implicaEsfuerzo()}
  }
}

class SocioRelajado inherits Socio {
  override method leAtrae(unaActividad){
    return !idiomasQueHabla.intersection(unaActividad.idiomas()).isEmpty()
  }
}

class TallerLiterario inherits Actividad {
  const property libros = []
  override method implicaEsfuerzo(){
    return libros.any({libro => libro.cantidadDePaginas() > 500})  || 
    ( libros.size() > 1 && libros.all({libro => libro.autor() == libros.first().autor()}) ) //¿Todos los libros tienen el mismo autor que el primer libro?
  }
  override method sirveParaBroncearse() = false
  override method dias() = libros.size() + 1
  override method esRecomendadaPara(unSocio) = unSocio.idiomas().size() > 1

  method agregar(unLibro) {
    libros.add(unLibro)
  }

  method quitar(unLibro) {
    libros.remove(unLibro)
  }
}

class Libro inherits TallerLiterario {
  const autor
  const idiomaDelLibro
  const property cantidadDePaginas

  method autor() = autor
  method idiomaDelLibro() = idiomaDelLibro
  method cantidadDePaginas() = cantidadDePaginas   
}
