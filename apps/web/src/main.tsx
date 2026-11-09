import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { App } from './App'
import './index.css'
import './lib/theme'
import { useAuth } from './stores/auth'

// ponytail: kill switch for the service worker an old build shipped. Delete once nobody is on it.
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.getRegistrations().then((rs) => {
    for (const r of rs) r.unregister()
  })
}

useAuth.getState().watch()

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>
)
