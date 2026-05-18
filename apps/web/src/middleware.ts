import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

// Rate limiting ve Auth checkleri için temel middleware yapısı.
// Not: Gerçek production Rate Limit için @upstash/ratelimit paketi önerilir.
export function middleware(request: NextRequest) {
	const response = NextResponse.next();

	// Temel CORS Ayarları
	const origin = request.headers.get("origin") ?? "";
	const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(",") || [];

	// Çoklu origin yönetimi (Varsayılan olarak kendi sunucusuna ve belirli originlere izin verilir)
	if (allowedOrigins.length === 0 || allowedOrigins.includes(origin)) {
		response.headers.set("Access-Control-Allow-Origin", origin || "*");
	}
	
	response.headers.set("Access-Control-Allow-Credentials", "true");
	response.headers.set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
	response.headers.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

	return response;
}

export const config = {
	matcher: [
		/*
		 * Tüm API istekleri ve hassas rotalar için çalışır.
		 * Statik dosyalar harici tutulur.
		 */
		"/((?!_next/static|_next/image|favicon.ico).*)",
	],
};
