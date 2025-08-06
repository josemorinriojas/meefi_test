import { Badge } from "@/components/ui/badge"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu"

export default function InvoiceTable({ invoices }: { invoices: any[] }) {
  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL

  const statusClasses: Record<string, string> = {
    pending: "bg-yellow-100 text-yellow-800 hover:bg-yellow-200",
    payed: "bg-green-100 text-green-800 hover:bg-green-200",
  }

  async function createPaymentComplement(invoiceId: number) {
    try {
      const response = await fetch(`${API_BASE_URL}/payment_complements`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ invoice_id: invoiceId }),
      })
      if (!response.ok) throw new Error("Error en la petición")
      location.reload()
      await response.json()
    } catch (error) {
      console.error(error)
    }
  }

  return (
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Cliente</TableHead>
          <TableHead>Fecha de emisión</TableHead>
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
            <TableCell className="text-right">
              {new Intl.NumberFormat("es-MX", { style: "currency", currency: "MXN" }).format(invoice.subtotal)}
            </TableCell>
            <TableCell className="text-right">
              {new Intl.NumberFormat("es-MX", { style: "currency", currency: "MXN" }).format(invoice.total)}
            </TableCell>
            <TableCell>
              <Badge className={statusClasses[invoice.status]}>{invoice.status}</Badge>
            </TableCell>
            <TableCell className="text-right">
              <DropdownMenu>
                <DropdownMenuTrigger>Acciones</DropdownMenuTrigger>
                <DropdownMenuContent>
                  <DropdownMenuItem onClick={() => createPaymentComplement(invoice.id)}>
                    Generar complemento de pago
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </TableCell>
          </TableRow>
        ))}
      </TableBody>
    </Table>
  )
}
