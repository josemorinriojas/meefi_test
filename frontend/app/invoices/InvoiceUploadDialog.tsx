import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"

export default function InvoiceUploadDialog({ onUploadSuccess }: { onUploadSuccess: () => void }) {
  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL
  const [file, setFile] = useState<File | null>(null)
  const [uploading, setUploading] = useState(false)

  async function handleFileUpload(e: React.FormEvent) {
    e.preventDefault()
    if (!file) {
      alert("Selecciona un archivo primero")
      return
    }
    const formData = new FormData()
    formData.append("xml_file", file)

    try {
      setUploading(true)
      const response = await fetch(`${API_BASE_URL}/invoices`, {
        method: "POST",
        body: formData,
      })
      if (!response.ok) throw new Error("Error al subir archivo")
      onUploadSuccess()
    } catch (err) {
      console.error(err)
      alert("Error al subir archivo")
    } finally {
      setUploading(false)
    }
  }

  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="outline">Cargar factura</Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Cargar factura</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleFileUpload} className="space-y-4">
          <Input type="file" onChange={(e) => setFile(e.target.files?.[0] || null)} />
          <Button type="submit" disabled={uploading}>
            {uploading ? "Subiendo..." : "Subir xml"}
          </Button>
        </form>
      </DialogContent>
    </Dialog>
  )
}
