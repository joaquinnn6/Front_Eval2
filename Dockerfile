FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.11-slim AS production
WORKDIR /app
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
COPY --from=builder /root/.local /home/appuser/.local
COPY . .
RUN chown -R appuser:appgroup /app
USER appuser
ENV PATH=/home/appuser/.local/bin:$PATH
EXPOSE 5000
CMD ["python", "app.py"]