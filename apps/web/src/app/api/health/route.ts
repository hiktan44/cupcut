export const dynamic = "force-dynamic";

export async function GET() {
	return Response.json(
		{
			status: "ok",
			timestamp: Date.now(),
			uptime: process.uptime(),
		},
		{ status: 200 }
	);
}
