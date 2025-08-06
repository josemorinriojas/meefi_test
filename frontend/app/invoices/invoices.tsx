import { useEffect, useState } from "react"
import { Table, TableBody, TableCaption, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"

export default function Invoices() {
  const [invoices, setInvoices] = useState([]) // estado para la data
  const [loading, setLoading] = useState(true) // estado para loader
  const [error, setError] = useState(null)     // estado para errores

  useEffect(() => {
    async function fetchInvoices() {
      try {
        const res = await fetch("/api/invoices") // tu endpoint
        if (!res.ok) throw new Error("Error al obtener facturas")
        const data = await res.json()
        setInvoices(data)
      } catch (err) {
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
        <CardHeader className="">
          <CardTitle>Listado de facturas</CardTitle>
        </CardHeader>
        <CardContent className="bg-white">
          {loading && <p>Cargando facturas...</p>}
          {error && <p className="text-red-500">{error}</p>}
					{!loading && !error && (
						<Table>
							<TableHeader>
								<TableRow>
									<TableHead>Cliente</TableHead>
									<TableHead>Fecha de emision</TableHead>
									<TableHead>UUID</TableHead>
									<TableHead className="text-right">Subtotal</TableHead>
									<TableHead className="text-right">Total</TableHead>
									<TableHead>Status</TableHead>
									<TableHead></TableHead>
								</TableRow>
							</TableHeader>
							<TableBody>
								{invoices.map((invoice) => (
									<TableRow key={invoice.id}>
										<TableCell className="font-medium">{invoice.receiver_name}</TableCell>
										<TableCell>{invoice.issued_at}</TableCell>
										<TableCell>{invoice.uuid}</TableCell>
										<TableCell className="text-right">{invoice.subtotal}</TableCell>
										<TableCell className="text-right">{invoice.total}</TableCell>
										<TableCell className="text-right">{invoice.status}</TableCell>
									</TableRow>
								))}
							</TableBody>
						</Table>
					)}
        </CardContent>
      </Card>
    </div>
  )
}