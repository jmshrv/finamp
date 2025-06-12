#pragma once

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(FinampApplication, finamp_application, FINAMP, APPLICATION,
                     GtkApplication)

/**
 * finamp_application_new:
 *
 * Creates a new Flutter-based application for Finamp.
 *
 * Returns: a new #FinampApplication.
 */
FinampApplication* finamp_application_new();
