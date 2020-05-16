### 微信小程序蓝牙连接智能硬件流程
可以通过手机下载APP应用来模拟蓝牙设备
* iOS lightblue
* Android BLE调试宝

### 微信小程序蓝牙常用相关Api
1. 初始化蓝牙适配器  
wx.openBluetoothAdapter  
  
2. 开始搜寻附近的蓝牙外围设备    
wx.startBluetoothDevicesDiscovery  
  
3. 获取搜索发现到的蓝牙设备的具体信息      
wx.onBluetoothDeviceFound  
返回值：  
信号强度：RSSI: number,  
该设备启动服务的UUID：advertisServiceUUIDs: array,  
设备UUID：deviceId: string,  
设备名称：localName: string,  
设备名称：name: string,  
serviceData: array object  
  
4. 通过设备UUID(deviceId)，来连接对应的设备。  
wx.createBLEConnection  
若小程序在之前已有搜索过某个蓝牙设备，并成功建立连接，可直接传入之前搜索获取的 deviceId 直接尝试连接该设备，无需进行搜索操作。  
  
5. 通过设备UUID(deviceId)，获取指定蓝牙设备所有服务(service)  
wx.getBLEDeviceServices  
返回值：  
设备UUID：deviceId: string,  
开启的服务列表：service: array,    
  
6. 通过设备UUID(deviceId)和服务UUID(serviceId)，获取蓝牙设备指定服务的所有特征值(characteristic)。  
wx.getBLEDeviceCharacteristics  
返回值：  
设备UUID：deviceId: string,  
服务UUID：serviceId: string,  
特征值列表：characteristic: array object  
特征值UUID：characteristic[0].uuid  
该特征值是否支持read操作：characteristic[0].properties.read  
该特征值是否支持write操作：characteristic[0].properties.write  
该特征值是否支持notify操作：characteristic[0].properties.notify  
该特征值是否支持indicate操作：characteristic[0].properties.indicate  
  
7. 开启notify。必须先启用 notifyBLECharacteristicValueChange 接口才能接收到设备推送的 notification  
wx.notifyBLECharacteristicValueChange  
  
8. 监听低功耗蓝牙设备的特征值变化  
wx.onBLECharacteristicValueChange  
返回值：  
设备UUID：deviceId: string,  
服务UUID：serviceId: string,  
特征值UUID：characteristicId: string,  
特征值: value: ArrayBuffer,  
  
10. 发送数据到设备中  
wx.writeBLECharacteristicValue  
  
11. 关闭蓝牙模块。  
wx.closeBluetoothAdapter  
  
12. 停止搜寻附近的蓝牙外围设备。  
wx.stopBluetoothDevicesDiscovery  
