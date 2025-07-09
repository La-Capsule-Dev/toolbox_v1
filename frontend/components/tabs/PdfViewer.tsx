import { Document, Page, pdfjs } from "react-pdf";

pdfjs.GlobalWorkerOptions.workerSrc = `//cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjs.version}/pdf.worker.min.js`;

export default function PDFViewer({ file }: { file: string }) {
    return (
        <Document className={"pdfContainer"} file={file}>
            <Page className={"pdfPage"} pageNumber={1} />
        </Document>
    );
}
