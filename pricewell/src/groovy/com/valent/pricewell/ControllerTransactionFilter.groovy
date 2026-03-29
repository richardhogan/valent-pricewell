package com.valent.pricewell

import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.support.DefaultTransactionDefinition
import org.springframework.transaction.support.TransactionTemplate
import org.springframework.web.filter.OncePerRequestFilter

import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse

/**
 * MIGRATION (Grails 2 → 7): Grails 2 controllers had an implicit Hibernate transaction
 * wrapping every request, which allowed save(flush:true) and delete() to work without
 * an explicit @Transactional on the controller.  In Grails 7, controllers have no
 * implicit transaction; only services annotated with @Transactional do.
 *
 * Rather than annotating 60+ controllers and 400+ save/delete call sites, this filter
 * restores the Grails 2 behaviour by wrapping every HTTP request in a transaction.
 * The transaction is committed after the controller action completes (before view
 * rendering), or rolled back if an exception is thrown.
 *
 * This filter runs AFTER Spring Security filters (via FilterRegistrationBean ordering)
 * so that authentication state is available inside the transaction.
 */
class ControllerTransactionFilter extends OncePerRequestFilter {

    PlatformTransactionManager transactionManager

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws IOException, jakarta.servlet.ServletException {
        DefaultTransactionDefinition txDef = new DefaultTransactionDefinition()
        txDef.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED)
        txDef.setReadOnly(false)

        TransactionTemplate tt = new TransactionTemplate(transactionManager, txDef)
        try {
            tt.execute { status ->
                try {
                    filterChain.doFilter(request, response)
                } catch (IOException | jakarta.servlet.ServletException e) {
                    status.setRollbackOnly()
                    throw e
                } catch (Exception e) {
                    status.setRollbackOnly()
                    throw new RuntimeException(e)
                }
            }
        } catch (RuntimeException e) {
            Throwable cause = e.getCause()
            if (cause instanceof IOException) throw (IOException) cause
            if (cause instanceof jakarta.servlet.ServletException) throw (jakarta.servlet.ServletException) cause
            throw e
        }
    }
}
