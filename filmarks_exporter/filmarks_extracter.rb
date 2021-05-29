# frozen_string_literal: true

require 'nokogiri'

module FilmarksExporter
   # extract filmarks page information
   class FilmarksExtracter
      def extract(html)
         doc = Nokogiri::HTML.parse(html, nil, 'utf-8')
         main_content = doc.xpath('//div[@class="p-content-detail__main"]')

         {
            title: main_content.xpath('h2[@class="p-content-detail__title"]/span').text,
            original: main_content.xpath('p[@class="p-content-detail__original"]').text,
            duration: main_content.xpath('//*[@class="p-content-detail__other-info"]').text[/(\d+分)/, 1],
            release_date: main_content.xpath('//*[@class="p-content-detail__other-info"]').text[/(\d+年\d+月\d+日)/, 1],
            genres: main_content.xpath('//*[@class="p-content-detail__genre"]//li').map(&:text),
            prime_info: extract_prime_info(main_content),
         }
      end

      def extract_prime_info(main_content)
         item = main_content.xpath('//ul[contains(@class, "p-content-detail-related-info-box__vod")]/li')
                            .to_a.filter { |f| f.text.include?('Prime') }.first
         return 'なし' unless item

         if item.text.include?('定額見放題')
            '定額見放題'
         else
            'レンタル'
         end
      end
   end
end
