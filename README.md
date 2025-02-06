# **Documentación de la App Gebesa Desk Controller**

## **Descripción del Proyecto**  
Aplicación Flutter para controlar y gestionar escritorios inteligentes con conectividad Bluetooth. La aplicación ofrece control de altura, gestión de rutinas y estadísticas de uso.

---

## **Funciones Principales**

### 1. **Autenticación**
- Registro y acceso de usuarios  
- Integración con Google Sign-In  
- Integración con Apple Sign-In  
- Funcionalidad de restablecimiento de contraseña  

### 2. **Control del Escritorio**
- Conexión Bluetooth con escritorios inteligentes  
- Controles de ajuste de altura  
- Configuración de posiciones de memoria (3 posiciones)  
- Seguimiento de altura en tiempo real  
- Conversión de unidades (Imperial/Métrico)  

### 3. **Rutinas**
- Crear rutinas personalizadas para el escritorio  
- Cambios de posición basados en temporizador  
- Seguimiento de calorías quemadas  
- Monitoreo de actividad (tiempo sentado/de pie)  

### 4. **Estadísticas**
- Seguimiento de actividad diaria  
- Registro de calorías quemadas  
- Posiciones de memoria más utilizadas  
- Tiempo dedicado sentado/de pie  

### 5. **Configuraciones**
- Personalización del tema (modo Claro/Oscuro)  
- Selección de idioma (Inglés/Español)  
- Unidades de medición (Métrico/Imperial)  
- Notificaciones push  
- Gestión del perfil  

---

## **Arquitectura Técnica**

### **Controladores**
- **AuthController:** Gestiona la autenticación y sesiones de usuario  
- **BluetoothController:** Administra las conexiones con dispositivos Bluetooth  
- **DeskController:** Controla las operaciones del escritorio y ajustes de altura  
- **RoutineController:** Gestiona las rutinas y temporizadores del escritorio  
- **StatisticsController:** Maneja el seguimiento de actividad y estadísticas  
- **ThemeController:** Gestiona la configuración del tema de la aplicación  
- **MeasurementController:** Maneja las conversiones de unidades y mediciones  

### **Integración con API**
- **AuthApi:** Puntos de acceso para autenticación  
- **UserApi:** Gestión de datos del usuario  
- **RoutineApi:** Gestión de rutinas  
- **StatisticsApi:** Seguimiento de estadísticas  
- **GoalsApi:** Gestión de metas del usuario  

### **Persistencia de Datos**
- **SharedPreferences:** Almacenamiento local  
- **Firebase:** Servicios backend  
- Autenticación basada en tokens  

### **Componentes de UI**
- Implementación de Material Design  
- Soporte de localización (Inglés/Español)  
- Implementación de temas personalizados  
- Diseños responsivos  
- Cuadros de diálogo personalizados y notificaciones tipo toast  

---

## **Dependencias**

### **Dependencias principales:**
- `flutter_blue_plus`: Conectividad Bluetooth  
- `firebase_core`: Integración con Firebase  
- `firebase_auth`: Autenticación  
- `google_sign_in`: Autenticación con Google  
- `provider`: Gestión de estado  
- `shared_preferences`: Almacenamiento local  
- `http`: Solicitudes API  
- `toastification`: Notificaciones tipo toast  

---

## **Compatibilidad con Plataformas**
- **iOS:** 12.0+  
- **Android**  

---

## **Configuración**
La aplicación requiere las siguientes configuraciones:
- Configuración de Firebase  
- Permisos de Bluetooth  
- Conectividad a Internet  
- Permisos de notificaciones push  
