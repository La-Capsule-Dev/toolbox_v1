use rusb::{Context,  UsbContext};
use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct UsbDeviceInfo {
    pub vendor_id: u16,
    pub product_id: u16,
    pub manufacturer: String,
    pub product: String,
    pub serial_number: String,
    pub bus_number: u8,
    pub address: u8,
    pub port_numbers: Vec<u8>,
}

#[derive(Debug)]
pub struct UsbPortTest {
    context: Context,
}

impl UsbPortTest {
    pub fn new() -> Result<Self, rusb::Error> {
        let context = Context::new()?;
        Ok(UsbPortTest { context })
    }

    /// Liste tous les périphériques USB connectés
    pub fn list_all_devices(&self) -> Result<Vec<UsbDeviceInfo>, rusb::Error> {
        let mut devices = Vec::new();
        
        for device in self.context.devices()?.iter() {
            if let Ok(device_desc) = device.device_descriptor() {
                let mut device_info = UsbDeviceInfo {
                    vendor_id: device_desc.vendor_id(),
                    product_id: device_desc.product_id(),
                    manufacturer: String::new(),
                    product: String::new(),
                    serial_number: String::new(),
                    bus_number: device.bus_number(),
                    address: device.address(),
                    port_numbers: device.port_numbers().unwrap_or_default(),
                };

                if let Ok(handle) = device.open() {
                    if let Ok(manufacturer) = handle.read_manufacturer_string_ascii(&device_desc) {
                        device_info.manufacturer = manufacturer;
                    }
                    if let Ok(product) = handle.read_product_string_ascii(&device_desc) {
                        device_info.product = product;
                    }
                    if let Ok(serial) = handle.read_serial_number_string_ascii(&device_desc) {
                        device_info.serial_number = serial;
                    }
                }

                devices.push(device_info);
            }
        }

        Ok(devices)
    }

    /// Trouve les périphériques par type (clavier, souris, stockage, etc.)
    pub fn find_devices_by_type(&self) -> Result<HashMap<String, Vec<UsbDeviceInfo>>, rusb::Error> {
        let mut device_types = HashMap::new();
        
        for device in self.context.devices()?.iter() {
            if let Ok(device_desc) = device.device_descriptor() {
                let class = device_desc.class_code();
                let subclass = device_desc.sub_class_code();
                let protocol = device_desc.protocol_code();
                
                let device_type = match (class, subclass, protocol) {
                    (0x03, _, _) => "HID (Human Interface Device)",
                    (0x08, _, _) => "Mass Storage",
                    (0x02, _, _) => "Communications",
                    (0x09, _, _) => "Hub",
                    (0x0E, _, _) => "Video",
                    (0x01, _, _) => "Audio",
                    (0x0B, _, _) => "Smart Card",
                    (0x0D, _, _) => "Content Security",
                    (0x0F, _, _) => "Personal Healthcare",
                    (0x10, _, _) => "Audio/Video Devices",
                    (0xDC, _, _) => "Diagnostic Device",
                    (0xE0, _, _) => "Wireless Controller",
                    (0xEF, _, _) => "Miscellaneous",
                    (0xFF, _, _) => "Vendor Specific",
                    _ => "Unknown",
                };
                
                let device_info = UsbDeviceInfo {
                    vendor_id: device_desc.vendor_id(),
                    product_id: device_desc.product_id(),
                    manufacturer: String::new(),
                    product: String::new(),
                    serial_number: String::new(),
                    bus_number: device.bus_number(),
                    address: device.address(),
                    port_numbers: device.port_numbers().unwrap_or_default(),
                };
                
                device_types.entry(device_type.to_string()).or_insert_with(Vec::new).push(device_info);
            }
        }
        
        Ok(device_types)
    }

    

    /// Génère un rapport détaillé des ports USB
    pub fn generate_report(&self) -> Result<Vec<String>, rusb::Error> {
        let mut report_lines = Vec::new();
        
        report_lines.push("=== RAPPORT DES PORTS USB ===".to_string());
        report_lines.push("".to_string());
        
        // Liste tous les périphériques
        let devices = self.list_all_devices()?;
        report_lines.push(format!("Nombre total de périphériques USB: {}", devices.len()));
        report_lines.push("".to_string());
        
        // Par type de périphérique
        let device_types = self.find_devices_by_type()?;
        report_lines.push("Répartition par type:".to_string());
        for (device_type, device_list) in &device_types {
            report_lines.push(format!("  {}: {} périphérique(s)", device_type, device_list.len()));
        }
        report_lines.push("".to_string());
        
        // Détails de chaque périphérique
        report_lines.push("Détails des périphériques:".to_string());
        for (i, device) in devices.iter().enumerate() {
            report_lines.push(format!("{}. {:04x}:{:04x} - {} {}", 
                i + 1, 
                device.vendor_id, 
                device.product_id,
                device.manufacturer,
                device.product
            ));
            report_lines.push(format!("Bus: {}, Adresse: {}, Ports: {:?}", 
                device.bus_number, 
                device.address, 
                device.port_numbers
            ));
            report_lines.push("".to_string()); // Ligne vide entre chaque périphérique
        }
        
        Ok(report_lines)
    }
}

/// Fonction principale pour tester les ports USB
pub fn test_usb_ports() -> Result<Vec<String>, String> {
    
    let usb_test = UsbPortTest::new()
        .map_err(|e| format!("Erreur lors de l'initialisation USB: {:?}", e))?;
    
    // Génération du rapport
    let report = usb_test.generate_report()
        .map_err(|e| format!("Erreur lors de la génération du rapport: {:?}", e))?;
    
    Ok(report)
}
