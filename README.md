

# Instrucciones para configurar el proyecto

Estimado colaborador, le agradecemos su interés en contribuir a este proyecto. Para configurarlo correctamente, siga los siguientes pasos:

1. Cree una carpeta para albergar el proyecto.

2. Clone el repositorio de GitHub:

https://github.com/12Edder12/ProyectoAgilesRestaurante.git

3. Ingrese a la carpeta del repositorio:

cd ProyectoAgilesRestaurante

4. Cree un proyecto vacío de Flutter con el nombre 'Pizzeria_Guerrin':

flutter create Pizzeria_Guerrin

5. Acceda a la carpeta del proyecto vacío:

cd Pizzeria_Guerrin

6. Elimine el archivo README.md, el archivo .gitignore y la carpeta 'lib' del proyecto vacío.

7. Mueva las carpetas de la aplicación Flutter a la carpeta del repositorio clonado.

8. Elimine la carpeta 'Pizzeria_Guerrin' vacía.

9. Resuelva los errores que puedan surgir.

10. Pegue el archivo 'google.json' en la carpeta 'android/app'.

11. Ejecute los siguientes comandos para instalar las dependencias:

flutter pub get

flutter pub add firebase_core

12. Asegúrese de que las dependencias en el archivo 'pubspec.yaml' coincidan con las siguientes:

-----------------------------------------------------
-----------------------------------------------------
name: Pizzeria_Guerrin
description: "A new Flutter project."

publish_to: 'none' # Remove this line if you wish to publish to pub.dev

version: 1.0.0+1

environment:
  sdk: '>=3.2.2 <4.0.0'

dependencies:

  adaptive_theme: ^3.4.1
  
  collection: ^1.18.0
  
  firebase_core: ^2.24.2
  
  flutter_web_plugins:
  
    sdk: flutter
    
  flutter:
  
    sdk: flutter
    
  smooth_page_indicator: ^1.0.0+2
  
  cupertino_icons: ^1.0.2
  
  provider: ^6.1.1
  
  firebase_auth: ^4.15.0
  
  cloud_firestore: ^4.14.0
  
  firebase_database: ^10.3.6
  
  intl: ^0.17.0
  
  gap: ^3.0.1
  
  go_router: ^13.0.0
  
  google_fonts: ^6.1.0
  
  intersperse: ^2.0.0
  
  recase: ^4.1.0
  
  responsive_framework: ^1.1.1
  
  simple_logger: ^1.9.0+3
  
  two_dimensional_scrollables: ^0.0.5
  
  flutter_masked_text2: ^0.9.1
  
  http: ^1.1.2
  
  firebase_analytics: ^10.7.4
  
  app_settings: ^5.1.1
  
  flutter_local_notifications: ^16.3.0
  
  onesignal_flutter: ^5.0.4
  
  syncfusion_flutter_datepicker: ^20.2.47
  
  fl_chart: ^0.66.0

  stripe_checkout: ^1.0.2
  
  uuid: ^4.3.3
  
  syncfusion_flutter_pdf: ^20.4.54
  
  open_file: ^3.3.2
  
  flutter_email_sender: ^6.0.2
  
  
dev_dependencies:

  flutter_test:
  
    sdk: flutter
    
  flutter_lints: ^3.0.1
  
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:

  android: "launcher_icon"
  
  image_path: "lib/img/res_logo1.png"
  
  min_sdk_android: 21 # android min sdk min:16, default 21
  
  web:
  
    generate: true
    
    image_path: "lib/img/res_logo1.png"
    
    background_color: "#hexcode"
    
    theme_color: "#hexcode"


flutter:

  uses-material-design: true
  
  assets: 
  
    - lib/img/


-----------------------------------------------------
-----------------------------------------------------

13. Ejecute los siguientes comandos para limpiar y actualizar las dependencias:

flutter clean
flutter pub get


¡Feliz desarrollo!
