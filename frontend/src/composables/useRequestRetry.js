const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms))

const shouldRetry = (error) => {
  const status = error?.response?.status
  if (!status) return true
  if (status >= 500) return true
  return status === 408 || status === 429
}

export const useRequestRetry = () => {
  const requestWithRetry = async (requestFn, options = {}) => {
    const retries = Number.isInteger(options.retries) ? options.retries : 2
    const delayMs = Number.isInteger(options.delayMs) ? options.delayMs : 300

    let lastError = null
    for (let attempt = 0; attempt <= retries; attempt += 1) {
      try {
        return await requestFn()
      } catch (error) {
        lastError = error
        const hasNextAttempt = attempt < retries
        if (!hasNextAttempt || !shouldRetry(error)) break
        await sleep(delayMs * (attempt + 1))
      }
    }

    throw lastError
  }

  return { requestWithRetry }
}
