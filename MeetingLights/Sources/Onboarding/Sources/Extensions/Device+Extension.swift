import Nanoleaf

extension DeviceIdentifier: Identifiable {
    public var id: String {
        self.name
    }
}
