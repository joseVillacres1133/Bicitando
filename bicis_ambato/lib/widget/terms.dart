import 'package:flutter/material.dart';
import '../style/style.dart';

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  final List<Map<String, String>> terms = [
    {
      'title': '1. Registro y Requisitos',
      'content': '''Requisitos del Usuario:
- Ser mayor de edad con capacidad jurídica
- Proporcionar datos personales verdaderos y verificables
- Subir fotografía legible de Cédula de Identidad o Pasaporte
- Registrar correo electrónico válido
- Proporcionar domicilio correcto

Usuarios Adicionales:
- Se permite registrar hasta 2 usuarios adicionales
- Máximo 3 registros totales por usuario principal
- Cada usuario adicional debe completar el proceso de registro completo'''
    },
    {
      'title': '2. Uso del Servicio',
      'content': '''Horario de Operación:
- Lunes a domingo: 08:00 a 17:00 horas
- Horario puede ser modificado previa notificación
- Disponibilidad sujeta a mantenimiento y eventos especiales

Tiempo de Préstamo:
- Máximo 2 horas por sesión
- Intervalo de 15 minutos entre un uso y otro
- Uso ilimitado dentro del horario de servicio

Procedimiento:
1. Registrarse en la aplicación móvil "BICITANDO"
2. Escanear código QR del candado de la bicicleta
3. Verificar el estado de la bicicleta (frenos, cambios, llantas, etc.)
4. Reportar cualquier daño antes de usar
5. Al finalizar, bloquear la bicicleta en la estación'''
    },
    {
      'title': '3. Derechos del Usuario',
      'content': '''• Usar una bicicleta disponible del sistema
- Solicitar información sobre el funcionamiento del sistema
- Formular comentarios, sugerencias, reclamos o quejas
- Conocer las penalizaciones aplicables
- Recibir notificaciones sobre cambios en el servicio'''
    },
    {
      'title': '4. Obligaciones del Usuario',
      'content': '''Responsabilidades Generales:
- Cuidar la bicicleta como propiedad propia
- Usar la bicicleta solo para transporte personal
- Verificar el correcto bloqueo al devolver
- Asumir custodia desde el retiro hasta la devolución
- Mantener datos personales actualizados
- Cumplir normas de tránsito vigentes

Seguridad:
- Usar casco obligatoriamente
- Utilizar equipos de protección necesarios
- Respetar señales de tránsito
- No circular en áreas peatonales designadas

Reportes:
- Comunicar inmediatamente cualquier problema técnico
- Reportar siniestros o accidentes de forma inmediata
- Denunciar cualquier delito relacionado con el sistema
- Permanecer en el lugar en caso de accidente

Daños:
- Cubrir costos de reparación por daños causados'''
    },
    {
      'title': '5. Prohibiciones',
      'content': '''Uso Personal:
- Prestar, alquilar o ceder la bicicleta a terceros
- Conducir bajo efectos de alcohol, drogas o sustancias
- Usar teléfono celular mientras se conduce
- Transportar dos o más personas a la vez
- Exceder el tiempo establecido (2 horas)

Bicicleta:
- Realizar reparaciones o modificaciones
- Desarmar o manipular elementos
- Utilizar en terrenos no aptos
- Realizar grafiti, manchas o rayar las bicicletas
- Salirse del perímetro de operación

Carga y Transporte:
- Transportar animales
- Transportar objetos que impidan visibilidad
- Transportar carga voluminosa o pesada

Sistema:
- Usar el sistema con fines comerciales
- Usar la imagen gráfica sin autorización
- Proporcionar datos falsos durante el registro'''
    },
    {
      'title': '6. Causales de Suspensión',
      'content':
          '''El servicio puede suspenderse temporal o definitivamente por:

- No devolver la bicicleta dentro del tiempo máximo
- Causar siniestros de tránsito usando el sistema
- Dañar intencionalmente elementos del sistema
- Utilizar la bicicleta en actos ilícitos
- Incumplir términos y condiciones

Consecuencias: Suspensión del acceso y posibles acciones legales'''
    },
    {
      'title': '7. Responsabilidad y Siniestros',
      'content': '''En Caso de Accidente:
- Comunicar inmediatamente al centro de atención
- Permanecer en el lugar de los hechos
- Salvaguardar integridad física y la bicicleta
- No realizar arreglos sin autorización
- Esperar al representante del GAD Municipalidad

Exclusiones de Responsabilidad:
El usuario asume responsabilidad exclusiva por daños causados por:
- Negligencia al efectuar u omitir actos
- Dolo o mala fe
- Falta o inexactitud de información
- Incumplimiento de obligaciones establecidas
- Conducción inadecuada de la bicicleta

Indemnización:
- El GAD no indemniza accidentes no causados por defectos en las bicicletas
- El incumplimiento de procedimientos puede limitar o declarar improcedente el pago'''
    },
    {
      'title': '8. Privacidad y Datos Personales',
      'content': '''Uso de Imagen:
- El usuario autoriza el uso de su imagen para promoción del sistema
- Solo mediante fotografía o video
- Sin generar responsabilidad ni obligación de pago

Protección de Datos:
- El GAD protege datos personales conforme a la Constitución y normativa vigente
- Tratamiento confidencial de información personal'''
    },
    {
      'title': '9. Solución de Controversias',
      'content': '''Proceso de Resolución:

1. Negociación: Búsqueda de solución por mutuo acuerdo

2. Mediación: Si no hay acuerdo, mediación en centro autorizado

3. Vía Judicial: Sometimiento a jueces competentes de Ambato

- El usuario renuncia a su fuero y domicilio para efectos de controversias'''
    },
    {
      'title': '10. Disposiciones Finales',
      'content':
          '''•El servicio se presta según disponibilidad por orden de llegada
- Las notificaciones se realizan al correo electrónico registrado
- El GAD puede modificar horarios previa notificación
- Si otra entidad pública administra el sistema, aplican las mismas condiciones
- La carta de compromiso es vinculante al aceptar estos términos'''
    },
    {
      'title': 'Aceptación',
      'content':
          '''Al registrarse en el sistema "BICITANDO", el usuario declara:

- Haber leído y comprendido estos términos y condiciones
- Aceptarlos en su totalidad
- Comprometerse a cumplirlos durante el uso del servicio
- Actuar sin dolo, lesión, mala fe, presión o intimidación

Aplicación Móvil: BICITANDO
Entidad Responsable: GAD Municipalidad de Ambato'''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: terms.map((term) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ExpansionTile(
                title: Text(
                  term['title']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      term['content']!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
