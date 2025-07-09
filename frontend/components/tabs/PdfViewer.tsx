export default function PDFViewer({ file }: { file: string }) {
    return (
        <div className="pdfWrapper">
            <iframe src={file} title="PDF Viewer" />
        </div>
    );
}
