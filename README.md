
# Instrucciones para configurar el proyecto

Estimado colaborador, le agradecemos su interés en contribuir a este proyecto. Para configurarlo correctamente, siga los siguientes pasos:

Cree una carpeta para albergar el proyecto.

Clone el repositorio de GitHub:

Bash
git clone https://github.com/12Edder12/LosPasadosEnAgiles3.git
Use code with caution. Learn more
Ingrese a la carpeta del repositorio:

Bash
cd LosPasadosEnAgiles3
Use code with caution. Learn more
Cree un proyecto vacío de Flutter con el nombre 'Pizzeria_Guerrin':

Bash
flutter create Pizzeria_Guerrin
Use code with caution. Learn more
Acceda a la carpeta del proyecto vacío:

Bash
cd Pizzeria_Guerrin
Use code with caution. Learn more
Elimine el archivo README.md, el archivo .gitignore y la carpeta 'lib' del proyecto vacío.

Mueva las carpetas de la aplicación Flutter a la carpeta del repositorio clonado.

Elimine la carpeta 'Pizzeria_Guerrin' vacía.

Resuelva los errores que puedan surgir.

Pegue el archivo 'google.json' en la carpeta 'android/app'.

Ejecute los siguientes comandos para instalar las dependencias:

Bash
flutter pub get
flutter pub add firebase_core
Use code with caution. Learn more
Asegúrese de que las dependencias en el archivo 'pubspec.yaml' coincidan con las siguientes:

(Inserte aquí el código de dependencias del archivo 'pubspec.yaml')

Ejecute los siguientes comandos para limpiar y actualizar las dependencias:

Bash
flutter clean
flutter pub get
Use code with caution. Learn more
Agradecemos su colaboración y quedamos a su disposición para cualquier consulta.

Por favor, no dude en contactarnos si tiene alguna duda o necesita asistencia adicional.

¡Feliz desarrollo!
