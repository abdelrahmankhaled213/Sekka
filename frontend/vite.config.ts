import path from "path"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"
import sourceIdentifierPlugin from "vite-plugin-source-identifier"

// Railway / Vite production detection
const isProd = process.env.NODE_ENV === "production"

export default defineConfig({
  plugins: [
    react(),
    sourceIdentifierPlugin({
      enabled: !isProd, // يشتغل في dev فقط
      attributePrefix: "data-matrix",
      includeProps: true,
    }),
  ],

  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },

 
  server: {
    host: true,
    port: 5173,
  },

  preview: {
    host: true,
    port: 5173,
  },
})