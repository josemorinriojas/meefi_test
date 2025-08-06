import { useEffect, useState } from "react"
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"
import InvoiceTable from "./InvoiceTable"
import InvoiceUploadDialog from "./InvoiceUploadDialog"

export default function Invoices() {
  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL
  const [invoices, setInvoices] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function fetchInvoices() {
      try {
        const res = await fetch(`${API_BASE_URL}/3/cfdis/invoices`)
        if (!res.ok) throw new Error("Error al obtener facturas")
        const data = await res.json()
        setInvoices(data)
      } catch (err: any) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }
    fetchInvoices()
  }, [])

  return (
    <div className="flex justify-center p-6">
      <Card className="w-full max-w-7xl bg-gray-100 pb-0">
        <CardHeader className="flex w-full justify-between items-center">
          <CardTitle className="text-lg">Listado de facturas</CardTitle>
          <InvoiceUploadDialog onUploadSuccess={() => location.reload()} />
        </CardHeader>

        <CardContent className="bg-white">
          {loading && <p>Cargando facturas...</p>}
          {error && <p className="text-red-500">{error}</p>}
          {!loading && !error && <InvoiceTable invoices={invoices} />}
        </CardContent>
      </Card>
    </div>
  )
}
