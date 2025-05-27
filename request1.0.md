### **Lộ Trình Chi Tiết Hướng Dẫn AI Agent Tích Hợp Facebook SDK & Thiết Lập Quảng Cáo Ứng Dụng**  

#### **Mục Tiêu**:  
- Tích hợp Facebook SDK vào ứng dụng Android để theo dõi sự kiện và hỗ trợ quảng cáo.  
- Thiết lập chiến dịch quảng cáo trên Meta (Facebook Ads) để tối ưu lượt cài đặt ứng dụng từ Google Play.  

---

## **Bước 1: Chuẩn Bị Ứng Dụng Trên Google Play & Facebook Developer**  
**Đăng ký ứng dụng trên Google Play**  
   - Đảm bảo ứng dụng đã có trên Google Play (vd: `com.hellovietnam.compassapp_vn`).  
   - Lấy **URL Google Play Store** của ứng dụng (vd: `https://play.google.com/store/apps/details?id=com.hellovietnam.compassapp_vn`).  

---

## **Bước 2: Tích Hợp Facebook SDK Vào Ứng Dụng Android**  
### **2.1. Thêm Facebook SDK vào `build.gradle`**  
- Mở **`build.gradle (Module: app)`** và thêm:  
  ```gradle
  dependencies {
      implementation 'com.facebook.android:facebook-android-sdk:[16.0,17.0)'
  }
  ```
- Đồng bộ dự án (Sync Project).  

### **2.2. Khai Báo Facebook App ID trong `strings.xml`**  
- Mở **`/app/src/main/res/values/strings.xml`** và thêm:  
  ```xml
  <string name="facebook_app_id">1010457991232883</string>
  ```

### **2.3. Cập Nhật `AndroidManifest.xml`**  
- Thêm quyền Internet và khai báo Facebook App ID:  
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  
  <application ...>
      <meta-data 
          android:name="com.facebook.sdk.ApplicationId" 
          android:value="@string/facebook_app_id" />
  </application>
  ```

### **2.4. Thiết Lập Deep Linking**  
- Khai báo **MainActivity** trong `AndroidManifest.xml`:  
  ```xml
  <activity android:name="com.example.myapp.MainActivity">
      <intent-filter>
          <action android:name="android.intent.action.VIEW" />
          <category android:name="android.intent.category.DEFAULT" />
          <category android:name="android.intent.category.BROWSABLE" />
          <data android:scheme="https" android:host="www.example.com" />
      </intent-filter>
  </activity>
  ```

---
### **Kết Luận**  
- **AI Agent** có thể tự động hóa quy trình:  
  1. **Tích hợp SDK** bằng cách đọc & chỉnh sửa file `build.gradle`, `AndroidManifest.xml`.  
  2. **Thiết lập quảng cáo** thông qua API Facebook Marketing.  
  3. **Giám sát & báo cáo** hiệu suất chiến dịch.  

✅ **Kết quả**: Ứng dụng được quảng cáo hiệu quả, tăng lượt cài đặt từ Google Play.