# Configuração do Google Maps - Resolução do Problema

## ✅ Configurações já aplicadas:

### Android (android/app/src/main/AndroidManifest.xml):
- ✅ Adicionadas permissões de localização
- ✅ Configurada API Key do Google Maps
- ✅ Permissões de internet adicionadas

### iOS (ios/Runner/Info.plist):
- ✅ Adicionadas permissões de localização
- ✅ Configurada API Key do Google Maps
- ✅ Mensagens de permissão em português

### Arquivos verificados:
- ✅ google-services.json está presente e configurado
- ✅ pubspec.yaml tem as dependências corretas (google_maps_flutter, geolocator, permission_handler)

## 🔧 Próximos passos para resolver o problema:

### 1. Verificar API Key no Google Cloud Console
A API Key `AIzaSyDcsY2_h9F1RiULYumcj4o6zpxwmGjtQCU` precisa estar ativa e com as APIs corretas habilitadas:

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Selecione o projeto `fgl1-d05a3`
3. Vá em "APIs & Services" > "Library"
4. Certifique-se de que estas APIs estão habilitadas:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Geocoding API**
   - **Geolocation API**

### 2. Verificar restrições da API Key
1. Em "APIs & Services" > "Credentials"
2. Clique na API Key
3. Verifique as restrições:
   - **Application restrictions**: 
     - Para Android: Adicione o package name `com.tcc.flutter_fgl_1`
     - Para iOS: Adicione o bundle ID `com.tcc.flutterApplicationFgl`
   - **API restrictions**: Selecione "Restrict key" e escolha as APIs necessárias

### 3. Limpar e reconstruir o projeto
```bash
# Limpar o projeto
flutter clean

# Reinstalar dependências
flutter pub get

# Para Android
cd android
./gradlew clean
cd ..

# Executar o app
flutter run
```

### 4. Verificar logs de erro
Se o mapa ainda não funcionar, verifique os logs:
```bash
flutter run --verbose
```

Procure por mensagens como:
- "API key not found"
- "This API project is not authorized"
- "Quota exceeded"

## 🚨 Problemas comuns e soluções:

### Problema: "API key not found"
**Solução**: Verificar se a API Key está correta nos arquivos de configuração

### Problema: "This API project is not authorized"
**Solução**: Habilitar as APIs necessárias no Google Cloud Console

### Problema: "Quota exceeded"
**Solução**: Verificar limites de quota no Google Cloud Console

### Problema: Mapa aparece em branco
**Solução**: Verificar se as permissões de localização estão sendo concedidas

## 📱 Teste no dispositivo:
1. Execute o app em um dispositivo físico (não emulador)
2. Vá para "Adicionar Lavoura"
3. Toque em "Selecionar Localização"
4. O mapa deve aparecer com a localização atual

## 🔍 Debug adicional:
Se ainda houver problemas, adicione logs no código:

```dart
void _onMapCreated(GoogleMapController controller) {
  _mapController = controller;
  print('Mapa criado com sucesso!'); // Adicionar este log
}
```

## 📞 Suporte:
Se o problema persistir, verifique:
1. Conexão com internet
2. Permissões do dispositivo
3. Logs detalhados do Flutter
4. Status das APIs no Google Cloud Console

