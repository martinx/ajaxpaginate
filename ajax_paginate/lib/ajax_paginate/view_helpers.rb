module AjaxPaginate
    module ViewHelpers
        @@default_options = {:method=>:get, :update=>''}
        # callbacks = %{update loading loaded interactive success failure complete}
        #
        # More documents see will_paginate and rails documents
        #
        def ajax_paginate(entries = @entries, options = {})
            total_pages = entries.page_count

            if total_pages > 1

                options = WillPaginate::ViewHelpers.pagination_options.merge options.symbolize_keys

                page, param = entries.current_page, options.delete(:param_name)

                inner_window, outer_window = options.delete(:inner_window).to_i, options.delete(:outer_window).to_i
                min = page - inner_window
                max = page + inner_window
                # adjust lower or upper limit if other is out of bounds
                if max > total_pages then
                    min -= max - total_pages
                elsif min < 1  then
                    max += 1 - min
                end

                current   = min..max
                beginning = 1..(1 + outer_window)
                tail      = (total_pages - outer_window)..total_pages
                visible   = [beginning, current, tail].map(&:to_a).flatten.sort.uniq
                links, prev = [], 0

                visible.each do |n|
                    next if n < 1
                    break if n > total_pages

                    unless n - prev > 1
                        prev = n
                        links << remote_page_link_or_span((n != page ? n : nil), 'current', n, param, options)
                    else
                        # ellipsis represents the gap between windows
                        prev = n - 1
                        links << '...'
                        redo
                    end
                end

                # next and previous buttons
                links.unshift remote_page_link_or_span(entries.previous_page, 'disabled', options.delete(:prev_label), param, options)
                links.push    remote_page_link_or_span(entries.next_page,     'disabled', options.delete(:next_label), param, options)

                content_tag :div, links.join(options.delete(:separator)), options
            end
        end

        protected

        def remote_page_link_or_span(page, span_class, text, param, options)
            unless page
                content_tag :span, text, :class => span_class
            else
                # page links should preserve GET parameters, so we merge params
                __options = @@default_options.merge(options)
                __options[:url]=params.merge(param.to_sym => (page !=1 ? page : nil))
                link_to_remote text, __options
            end
        end

    end
end