.PHONY: fmt				
fmt:
	@gci overwrite ./pkg/
	@go fmt ./pkg/...
	@gofumpt -w ./pkg/

.PHONY: e2e
e2e: fmt
	@./cicd-scripts/run-e2e-tests.sh

.PHONY: vendor			
vendor:
	@go mod vendor

.PHONY: clean-vendor		
clean-vendor:
	-@rm -rf vendor