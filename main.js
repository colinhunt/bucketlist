document.addEventListener('DOMContentLoaded', () => {
    const elm = Elm.Main.fullscreen()

    elm.ports.save.subscribe((settings) => {
        console.log("elm.ports.save:")
        console.log(settings)
        chrome.storage.sync.set(settings, () => {
          if (chrome.runtime.lastError !== undefined) {
            console.log("chrome.storage.sync.set failure, reason:")
            console.log(chrome.runtime.lastError.message)
            return
          }
          console.log("chrome.storage.sync.set success")
          console.log(settings)
        })
    })

    elm.ports.load.subscribe((keys) => {
        console.log("elm.ports.load:")
        console.log(keys)
        chrome.storage.sync.get(keys, (items) => {
            if (chrome.runtime.lastError !== undefined) {
              console.log("chrome.storage.sync.get failure, reason:")
              console.log(chrome.runtime.lastError.message)
              return
            }
            console.log("chrome.storage.sync.get success")
            console.log(items)
            elm.ports.onLoad.send(items)
        })
    })
})