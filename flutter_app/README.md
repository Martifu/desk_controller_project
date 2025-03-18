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
- Conexión Bluetooth con escritorios inteligentes (servicio FF12)
- Controles de ajuste de altura (subir/bajar)
- Configuración de posiciones de memoria (3 posiciones)  
- Seguimiento de altura en tiempo real  
- Conversión de unidades (Imperial/Métrico)
- Personalización del nombre del dispositivo
- Detección automática de rango de altura (mínimo/máximo)

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
- **DeskApi:** Registro y sincronización de dispositivos

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

## **Protocolo Bluetooth**

### **Dispositivos Compatibles**
Esta rama soporta exclusivamente dispositivos con el servicio FF12, utilizando las siguientes características:
- **FF01:** Característica de control (envío de comandos)
- **FF02:** Característica de reporte (recepción de notificaciones de altura)
- **FF06:** Característica de información del dispositivo (cambio de nombre)

### **Comandos Principales**

#### Comando Inicial (Handshake)
```dart
void _sendInitialCommand() {
  targetCharacteristic
      ?.write([0xF1, 0xF1, 0x07, 0x00, 0x07, 0x7E], withoutResponse: true);
}
```

#### Solicitar Rango de Altura
```dart
void requestHeightRange() {
  List<int> command = [0xF1, 0xF1, 0x0C, 0x00, 0x0C, 0x7E];
  targetCharacteristic!.write(command, withoutResponse: true);
}
```

#### Mover Hacia Arriba
```dart
void moveUp() {
  final data = [0xF1, 0xF1, 0x01, 0x00, 0x01, 0x7E];
  targetCharacteristic!.write(data, withoutResponse: true);
}
```

#### Mover Hacia Abajo
```dart
void moveDown() {
  final data = [0xF1, 0xF1, 0x02, 0x00, 0x02, 0x7E];
  targetCharacteristic!.write(data, withoutResponse: true);
}
```

#### Detener Movimiento
```dart
void sendStopCommand() {
  List<int> data = [0xF1, 0xF1, 0x0A, 0x00, 0x0A, 0x7E];
  targetCharacteristic!.write(data, withoutResponse: true);
}
```

#### Configurar Memoria 1
```dart
void setupMemory1() async {
  final data = [0xF1, 0xF1, 0x03, 0x00, 0x03, 0x7E];
  targetCharacteristic!.write(data, withoutResponse: true);
  memory1Configured = true;
  notifyListeners();
  
  // Guardar en SharedPreferences y API
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble('memory1', heightIN!);
  
  if (await InternetConnection().hasInternetAccess) {
    DeskApi.saveMemoryDesk(1, heightIN!);
  }
  
  // Resetear el indicador después de 2 segundos
  Future.delayed(const Duration(seconds: 2), () {
    memory1Configured = false;
    notifyListeners();
  });
}
```

#### Configurar Memoria 2
```dart
void setupMemory2() async {
  final data = [0xF1, 0xF1, 0x04, 0x00, 0x04, 0x7E];
  targetCharacteristic!.write(data, withoutResponse: true);
  memory2Configured = true;
  notifyListeners();
  
  // Guardar en SharedPreferences y API
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble('memory2', heightIN!);
  
  if (await InternetConnection().hasInternetAccess) {
    DeskApi.saveMemoryDesk(2, heightIN!);
  }
  
  // Resetear el indicador después de 2 segundos
  Future.delayed(const Duration(seconds: 2), () {
    memory2Configured = false;
    notifyListeners();
  });
}
```

#### Configurar Memoria 3
```dart
void setupMemory3() async {
  final data = [0xF1, 0xF1, 0x25, 0x00, 0x25, 0x7E];
  targetCharacteristic!.write(data, withoutResponse: true);
  memory3Configured = true;
  notifyListeners();
  
  // Guardar en SharedPreferences y API
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble('memory3', heightIN!);
  
  if (await InternetConnection().hasInternetAccess) {
    DeskApi.saveMemoryDesk(3, heightIN!);
  }
  
  // Resetear el indicador después de 2 segundos
  Future.delayed(const Duration(seconds: 2), () {
    memory3Configured = false;
    notifyListeners();
  });
}
```

#### Mover a Memoria 1
```dart
void moveMemory1() {
  final data = [0xF1, 0xF1, 0x05, 0x00, 0x05, 0x7E];
  targetCharacteristic!.write(data, withoutResponse: true);
  memorySlot = 1;
  notifyListeners();
}
```

#### Mover a Memoria 2
```dart
void moveMemory2() {
  final data = [0xF1, 0xF1, 0x06, 0x00, 0x06, 0x7E];
  targetCharacteristic!.write(data, withoutResponse: true);
  memorySlot = 2;
  notifyListeners();
}
```

#### Mover a Memoria 3
```dart
void moveMemory3() {
  final data = [0xF1, 0xF1, 0x27, 0x00, 0x27, 0x7E];
  targetCharacteristic!.write(data, withoutResponse: true);
  memorySlot = 3;
  notifyListeners();
}
```

#### Mover a Altura Específica
```dart
void moveToHeight(int mm) async {
  if (targetCharacteristic != null) {
    // Generar el comando con la altura deseada
    String hexStr = mm.toRadixString(16).padLeft(4, '0');

    List<int> bytes = [];
    for (int i = 0; i < hexStr.length; i += 2) {
      bytes.add(int.parse(hexStr.substring(i, i + 2), radix: 16));
    }

    List<int> command = periferial(bytes);

    // Enviar el comando al targetCharacteristic
    await targetCharacteristic!
        .write(command, withoutResponse: true, allowLongWrite: false);
  }
}

List<int> periferial(List<int> hexValue) {
  List<int> periferialCommand = List.filled(8, 0);
  int checkSum = 0x00;

  periferialCommand[0] = 0xF1;
  periferialCommand[1] = 0xF1;
  periferialCommand[2] = 0x1B;
  periferialCommand[3] = 0x02;

  int highByte = hexValue[0];
  int lowByte = hexValue[1];

  periferialCommand[4] = highByte;
  periferialCommand[5] = lowByte;

  // Calcular el checksum
  for (int i = 2; i < 6; i++) {
    checkSum += periferialCommand[i];
  }
  periferialCommand[6] = checkSum & 0xFF;
  periferialCommand[7] = 0x7E;

  return periferialCommand;
}
```

### **Cambio de Nombre del Dispositivo**

```dart
List<int> convertNameToHex(String name) {
  // Crear una lista de enteros con la longitud del nombre
  List<int> hexArray = List<int>.filled(name.length, 0);

  // Recorrer cada letra del nombre
  for (int i = 0; i < name.length; i++) {
    hexArray[i] = name.codeUnitAt(i);
  }

  return hexArray;
}

Future<void> changeName(String name) async {
  if (deviceInfoCharacteristic != null) {
    // Convertir el nombre a bytes ASCII
    List<int> hexArray = convertNameToHex(name);

    print("Nombre convertido a hex: $hexArray");

    // Crear el comando con la longitud adecuada
    List<int> command = [];

    // Copiar el nombre en el comando
    command.addAll(hexArray);

    print("Comando final: $command");

    // Enviar el comando al dispositivo
    await deviceInfoCharacteristic!.write(command, withoutResponse: false);

    // Save name to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_name', name);

    deviceName = name;
    notifyListeners();
  }
}
```

### **Escucha de Notificaciones**

```dart
Future<void> _listenForNotifications(BuildContext context) async {
  if (reportCharacteristic != null) {
    await reportCharacteristic!.setNotifyValue(true);
    reportCharacteristic!.onValueReceived.listen((event) async {
      // Resetear temporizadores
      _resetNoDataTimer(context);
      _resetStableTimer();

      // Procesar datos de rango de altura
      if (event[0] == 0xF2 && event[1] == 0xF2 && event[2] == 0x07) {
        // Extraer los valores
        int max = (event[4] << 8) | event[5]; // Altura máxima en mm
        int min = (event[6] << 8) | event[7]; // Altura mínima en mm

        minHeightMM = min.toDouble();
        maxHeightMM = max.toDouble();

        heightMM = inchesToMm(heightIN!);

        print('Altura máxima: ${max / 25.4} in');
        print('Altura mínima: ${min / 25.4} in');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setDouble('maxHeightDesk', max / 25.4);
        prefs.setDouble('minHeightDesk', min / 25.4);

        maxHeight = max / 25.4;
        minHeight = min / 25.4;

        progress = calculateProgressPercentage(heightIN!, minHeight, maxHeight);

        firstConnection = false;
        notifyListeners();
        return;
      }

      // Procesar datos de altura actual
      final dataH = event[4];
      final dataL = event[5];

      // Convertir a hexadecimal y luego a decimal
      final hex = dataH.toRadixString(16).padLeft(2, '0') +
          dataL.toRadixString(16).padLeft(2, '0');
      final decimal = int.parse(hex, radix: 16);

      // Convertir a pulgadas
      final distance = decimal / 10;

      // Actualizar altura
      heightIN = distance;
      heightHex = [dataH, dataL];

      // Verificar si la altura está dentro del rango esperado
      if (heightIN! < minHeight || heightIN! > maxHeight) {
        return;
      }

      heightMM = inchesToMm(heightIN!);

      print("Altura actual: $heightIN pulgadas");
      print("Altura actual: $heightMM mm");

      progress = calculateProgressPercentage(heightIN!, minHeight, maxHeight);

      notifyListeners();
    });
  }
}
```

### **Conversión de Unidades**

```dart
double hexToCm(int mm1, int mm2) {
  int heightMm = (mm1 << 8) | mm2;
  return heightMm / 10.0;
}

double hexToInches(int mm1, int mm2) {
  int heightMm = (mm1 << 8) | mm2;
  return heightMm / 25.4;
}

int cmToMm(double cm) {
  return (cm * 10).round();
}

double inchesToMm(double inches) {
  return inches * 25.4; // 1 inch = 25.4 mm (exact conversion)
}

int hexToMm(int dataH, int dataL) {
  return (dataH << 8) | dataL;
}

double mmToInches(double mm) {
  return mm / 25.4;
}

double mmToCm(double mm) {
  return mm / 10;
}
```

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
- `permission_handler`: Gestión de permisos
- `open_settings_plus`: Acceso a configuraciones del sistema
- `internet_connection_checker_plus`: Verificación de conectividad

---

## **Compatibilidad con Plataformas**
- **iOS:** 12.0+  
- **Android:** 6.0+ (API 23+)

---

## **Configuración**
La aplicación requiere las siguientes configuraciones:
- Configuración de Firebase  
- Permisos de Bluetooth (ubicación en Android)
- Conectividad a Internet  
- Permisos de notificaciones push  

---

## **Limitaciones Actuales**
- Esta rama solo soporta dispositivos con el servicio FF12
- La funcionalidad web está limitada debido a las restricciones de Bluetooth en navegadores
