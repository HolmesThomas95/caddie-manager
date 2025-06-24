import SwiftUI
import PDFKit

struct PDFExporter {
    static func export(view: AnyView) {
        let controller = UIHostingController(rootView: view)
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: targetSize))
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            view?.layer.render(in: ctx.cgContext)
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("groups.pdf")
        do {
            try data.write(to: url)
            let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true)
        } catch {
            print("Failed to write PDF: \(error)")
        }
    }
}
