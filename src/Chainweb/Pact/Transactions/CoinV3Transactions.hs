{-# LANGUAGE OverloadedStrings #-}

-- This module is auto-generated. DO NOT EDIT IT MANUALLY.

module Chainweb.Pact.Transactions.CoinV3Transactions ( transactions ) where

import Data.Bifunctor (first)
import System.IO.Unsafe

import Chainweb.Transaction
import Chainweb.Utils

transactions :: [Pact4Transaction]
transactions =
  let decodeTx t =
        fromEitherM . (first (userError . show)) . codecDecode (pact4PayloadCodec maxBound) =<< decodeB64UrlNoPaddingText t
  in unsafePerformIO $ mapM decodeTx [
    "eyJoYXNoIjoiRkd0RlNjcW1neklEQzlENkUwSUtQSFN0ZDhPdW9JdVhRanp4TFdyWTBZayIsInNpZ3MiOltdLCJjbWQiOiJ7XCJuZXR3b3JrSWRcIjpudWxsLFwicGF5bG9hZFwiOntcImV4ZWNcIjp7XCJkYXRhXCI6bnVsbCxcImNvZGVcIjpcIlxcbihtb2R1bGUgY29pbiBHT1ZFUk5BTkNFXFxuXFxuICBAZG9jIFxcXCInY29pbicgcmVwcmVzZW50cyB0aGUgS2FkZW5hIENvaW4gQ29udHJhY3QuIFRoaXMgY29udHJhY3QgcHJvdmlkZXMgYm90aCB0aGUgXFxcXFxcbiAgXFxcXGJ1eS9yZWRlZW0gZ2FzIHN1cHBvcnQgaW4gdGhlIGZvcm0gb2YgJ2Z1bmQtdHgnLCBhcyB3ZWxsIGFzIHRyYW5zZmVyLCAgICAgICBcXFxcXFxuICBcXFxcY3JlZGl0LCBkZWJpdCwgY29pbmJhc2UsIGFjY291bnQgY3JlYXRpb24gYW5kIHF1ZXJ5LCBhcyB3ZWxsIGFzIFNQViBidXJuICAgIFxcXFxcXG4gIFxcXFxjcmVhdGUuIFRvIGFjY2VzcyB0aGUgY29pbiBjb250cmFjdCwgeW91IG1heSB1c2UgaXRzIGZ1bGx5LXF1YWxpZmllZCBuYW1lLCAgXFxcXFxcbiAgXFxcXG9yIGlzc3VlIHRoZSAnKHVzZSBjb2luKScgY29tbWFuZCBpbiB0aGUgYm9keSBvZiBhIG1vZHVsZSBkZWNsYXJhdGlvbi5cXFwiXFxuXFxuICBAbW9kZWxcXG4gICAgWyAoZGVmcHJvcGVydHkgY29uc2VydmVzLW1hc3NcXG4gICAgICAgICg9IChjb2x1bW4tZGVsdGEgY29pbi10YWJsZSAnYmFsYW5jZSkgMC4wKSlcXG5cXG4gICAgICAoZGVmcHJvcGVydHkgdmFsaWQtYWNjb3VudCAoYWNjb3VudDpzdHJpbmcpXFxuICAgICAgICAoYW5kXFxuICAgICAgICAgICg-PSAobGVuZ3RoIGFjY291bnQpIDMpXFxuICAgICAgICAgICg8PSAobGVuZ3RoIGFjY291bnQpIDI1NikpKVxcbiAgICBdXFxuXFxuICAoaW1wbGVtZW50cyBmdW5naWJsZS12MilcXG5cXG4gIChibGVzcyBcXFwidXRfSl9aTmtveWFQVUVKaGl3VmVXbmtTUW45SlQ5c1FDV0tkampWVnJXb1xcXCIpXFxuXFxuICA7IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tXFxuICA7IFNjaGVtYXMgYW5kIFRhYmxlc1xcblxcbiAgKGRlZnNjaGVtYSBjb2luLXNjaGVtYVxcbiAgICBAZG9jIFxcXCJUaGUgY29pbiBjb250cmFjdCB0b2tlbiBzY2hlbWFcXFwiXFxuICAgIEBtb2RlbCBbIChpbnZhcmlhbnQgKD49IGJhbGFuY2UgMC4wKSkgXVxcblxcbiAgICBiYWxhbmNlOmRlY2ltYWxcXG4gICAgZ3VhcmQ6Z3VhcmQpXFxuXFxuICAoZGVmdGFibGUgY29pbi10YWJsZTp7Y29pbi1zY2hlbWF9KVxcblxcbiAgOyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLVxcbiAgOyBDYXBhYmlsaXRpZXNcXG5cXG4gIChkZWZjYXAgR09WRVJOQU5DRSAoKVxcbiAgICAoZW5mb3JjZSBmYWxzZSBcXFwiRW5mb3JjZSBub24tdXBncmFkZWFiaWxpdHlcXFwiKSlcXG5cXG4gIChkZWZjYXAgR0FTICgpXFxuICAgIFxcXCJNYWdpYyBjYXBhYmlsaXR5IHRvIHByb3RlY3QgZ2FzIGJ1eSBhbmQgcmVkZWVtXFxcIlxcbiAgICB0cnVlKVxcblxcbiAgKGRlZmNhcCBDT0lOQkFTRSAoKVxcbiAgICBcXFwiTWFnaWMgY2FwYWJpbGl0eSB0byBwcm90ZWN0IG1pbmVyIHJld2FyZFxcXCJcXG4gICAgdHJ1ZSlcXG5cXG4gIChkZWZjYXAgR0VORVNJUyAoKVxcbiAgICBcXFwiTWFnaWMgY2FwYWJpbGl0eSBjb25zdHJhaW5pbmcgZ2VuZXNpcyB0cmFuc2FjdGlvbnNcXFwiXFxuICAgIHRydWUpXFxuXFxuICAoZGVmY2FwIFJFTUVESUFURSAoKVxcbiAgICBcXFwiTWFnaWMgY2FwYWJpbGl0eSBmb3IgcmVtZWRpYXRpb24gdHJhbnNhY3Rpb25zXFxcIlxcbiAgICB0cnVlKVxcblxcbiAgKGRlZmNhcCBERUJJVCAoc2VuZGVyOnN0cmluZylcXG4gICAgXFxcIkNhcGFiaWxpdHkgZm9yIG1hbmFnaW5nIGRlYml0aW5nIG9wZXJhdGlvbnNcXFwiXFxuICAgIChlbmZvcmNlLWd1YXJkIChhdCAnZ3VhcmQgKHJlYWQgY29pbi10YWJsZSBzZW5kZXIpKSlcXG4gICAgKGVuZm9yY2UgKCE9IHNlbmRlciBcXFwiXFxcIikgXFxcInZhbGlkIHNlbmRlclxcXCIpKVxcblxcbiAgKGRlZmNhcCBDUkVESVQgKHJlY2VpdmVyOnN0cmluZylcXG4gICAgXFxcIkNhcGFiaWxpdHkgZm9yIG1hbmFnaW5nIGNyZWRpdGluZyBvcGVyYXRpb25zXFxcIlxcbiAgICAoZW5mb3JjZSAoIT0gcmVjZWl2ZXIgXFxcIlxcXCIpIFxcXCJ2YWxpZCByZWNlaXZlclxcXCIpKVxcblxcbiAgKGRlZmNhcCBST1RBVEUgKGFjY291bnQ6c3RyaW5nKVxcbiAgICBAZG9jIFxcXCJBdXRvbm9tb3VzbHkgbWFuYWdlZCBjYXBhYmlsaXR5IGZvciBndWFyZCByb3RhdGlvblxcXCJcXG4gICAgQG1hbmFnZWRcXG4gICAgdHJ1ZSlcXG5cXG4gIChkZWZjYXAgVFJBTlNGRVI6Ym9vbFxcbiAgICAoIHNlbmRlcjpzdHJpbmdcXG4gICAgICByZWNlaXZlcjpzdHJpbmdcXG4gICAgICBhbW91bnQ6ZGVjaW1hbFxcbiAgICApXFxuICAgIEBtYW5hZ2VkIGFtb3VudCBUUkFOU0ZFUi1tZ3JcXG4gICAgKGVuZm9yY2UgKCE9IHNlbmRlciByZWNlaXZlcikgXFxcInNhbWUgc2VuZGVyIGFuZCByZWNlaXZlclxcXCIpXFxuICAgIChlbmZvcmNlLXVuaXQgYW1vdW50KVxcbiAgICAoZW5mb3JjZSAoPiBhbW91bnQgMC4wKSBcXFwiUG9zaXRpdmUgYW1vdW50XFxcIilcXG4gICAgKGNvbXBvc2UtY2FwYWJpbGl0eSAoREVCSVQgc2VuZGVyKSlcXG4gICAgKGNvbXBvc2UtY2FwYWJpbGl0eSAoQ1JFRElUIHJlY2VpdmVyKSlcXG4gIClcXG5cXG4gIChkZWZ1biBUUkFOU0ZFUi1tZ3I6ZGVjaW1hbFxcbiAgICAoIG1hbmFnZWQ6ZGVjaW1hbFxcbiAgICAgIHJlcXVlc3RlZDpkZWNpbWFsXFxuICAgIClcXG5cXG4gICAgKGxldCAoKG5ld2JhbCAoLSBtYW5hZ2VkIHJlcXVlc3RlZCkpKVxcbiAgICAgIChlbmZvcmNlICg-PSBuZXdiYWwgMC4wKVxcbiAgICAgICAgKGZvcm1hdCBcXFwiVFJBTlNGRVIgZXhjZWVkZWQgZm9yIGJhbGFuY2Uge31cXFwiIFttYW5hZ2VkXSkpXFxuICAgICAgbmV3YmFsKVxcbiAgKVxcblxcbiAgOyB2MyBjYXBhYmlsaXRpZXNcXG4gIChkZWZjYXAgUkVMRUFTRV9BTExPQ0FUSU9OXFxuICAgICggYWNjb3VudDpzdHJpbmdcXG4gICAgICBhbW91bnQ6ZGVjaW1hbFxcbiAgICApXFxuICAgIEBkb2MgXFxcIkV2ZW50IGZvciBhbGxvY2F0aW9uIHJlbGVhc2UsIGNhbiBiZSB1c2VkIGZvciBzaWcgc2NvcGluZy5cXFwiXFxuICAgIEBldmVudCB0cnVlXFxuICApXFxuXFxuICA7IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tXFxuICA7IENvbnN0YW50c1xcblxcbiAgKGRlZmNvbnN0IENPSU5fQ0hBUlNFVCBDSEFSU0VUX0xBVElOMVxcbiAgICBcXFwiVGhlIGRlZmF1bHQgY29pbiBjb250cmFjdCBjaGFyYWN0ZXIgc2V0XFxcIilcXG5cXG4gIChkZWZjb25zdCBNSU5JTVVNX1BSRUNJU0lPTiAxMlxcbiAgICBcXFwiTWluaW11bSBhbGxvd2VkIHByZWNpc2lvbiBmb3IgY29pbiB0cmFuc2FjdGlvbnNcXFwiKVxcblxcbiAgKGRlZmNvbnN0IE1JTklNVU1fQUNDT1VOVF9MRU5HVEggM1xcbiAgICBcXFwiTWluaW11bSBhY2NvdW50IGxlbmd0aCBhZG1pc3NpYmxlIGZvciBjb2luIGFjY291bnRzXFxcIilcXG5cXG4gIChkZWZjb25zdCBNQVhJTVVNX0FDQ09VTlRfTEVOR1RIIDI1NlxcbiAgICBcXFwiTWF4aW11bSBhY2NvdW50IG5hbWUgbGVuZ3RoIGFkbWlzc2libGUgZm9yIGNvaW4gYWNjb3VudHNcXFwiKVxcblxcbiAgOyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLVxcbiAgOyBVdGlsaXRpZXNcXG5cXG4gIChkZWZ1biBlbmZvcmNlLXVuaXQ6Ym9vbCAoYW1vdW50OmRlY2ltYWwpXFxuICAgIEBkb2MgXFxcIkVuZm9yY2UgbWluaW11bSBwcmVjaXNpb24gYWxsb3dlZCBmb3IgY29pbiB0cmFuc2FjdGlvbnNcXFwiXFxuXFxuICAgIChlbmZvcmNlXFxuICAgICAgKD0gKGZsb29yIGFtb3VudCBNSU5JTVVNX1BSRUNJU0lPTilcXG4gICAgICAgICBhbW91bnQpXFxuICAgICAgKGZvcm1hdCBcXFwiQW1vdW50IHZpb2xhdGVzIG1pbmltdW0gcHJlY2lzaW9uOiB7fVxcXCIgW2Ftb3VudF0pKVxcbiAgICApXFxuXFxuICAoZGVmdW4gdmFsaWRhdGUtYWNjb3VudCAoYWNjb3VudDpzdHJpbmcpXFxuICAgIEBkb2MgXFxcIkVuZm9yY2UgdGhhdCBhbiBhY2NvdW50IG5hbWUgY29uZm9ybXMgdG8gdGhlIGNvaW4gY29udHJhY3QgXFxcXFxcbiAgICAgICAgIFxcXFxtaW5pbXVtIGFuZCBtYXhpbXVtIGxlbmd0aCByZXF1aXJlbWVudHMsIGFzIHdlbGwgYXMgdGhlICAgIFxcXFxcXG4gICAgICAgICBcXFxcbGF0aW4tMSBjaGFyYWN0ZXIgc2V0LlxcXCJcXG5cXG4gICAgKGVuZm9yY2VcXG4gICAgICAoaXMtY2hhcnNldCBDT0lOX0NIQVJTRVQgYWNjb3VudClcXG4gICAgICAoZm9ybWF0XFxuICAgICAgICBcXFwiQWNjb3VudCBkb2VzIG5vdCBjb25mb3JtIHRvIHRoZSBjb2luIGNvbnRyYWN0IGNoYXJzZXQ6IHt9XFxcIlxcbiAgICAgICAgW2FjY291bnRdKSlcXG5cXG4gICAgKGxldCAoKGFjY291bnQtbGVuZ3RoIChsZW5ndGggYWNjb3VudCkpKVxcblxcbiAgICAgIChlbmZvcmNlXFxuICAgICAgICAoPj0gYWNjb3VudC1sZW5ndGggTUlOSU1VTV9BQ0NPVU5UX0xFTkdUSClcXG4gICAgICAgIChmb3JtYXRcXG4gICAgICAgICAgXFxcIkFjY291bnQgbmFtZSBkb2VzIG5vdCBjb25mb3JtIHRvIHRoZSBtaW4gbGVuZ3RoIHJlcXVpcmVtZW50OiB7fVxcXCJcXG4gICAgICAgICAgW2FjY291bnRdKSlcXG5cXG4gICAgICAoZW5mb3JjZVxcbiAgICAgICAgKDw9IGFjY291bnQtbGVuZ3RoIE1BWElNVU1fQUNDT1VOVF9MRU5HVEgpXFxuICAgICAgICAoZm9ybWF0XFxuICAgICAgICAgIFxcXCJBY2NvdW50IG5hbWUgZG9lcyBub3QgY29uZm9ybSB0byB0aGUgbWF4IGxlbmd0aCByZXF1aXJlbWVudDoge31cXFwiXFxuICAgICAgICAgIFthY2NvdW50XSkpXFxuICAgICAgKVxcbiAgKVxcblxcbiAgOyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLVxcbiAgOyBDb2luIENvbnRyYWN0XFxuXFxuICAoZGVmdW4gZ2FzLW9ubHkgKClcXG4gICAgXFxcIlByZWRpY2F0ZSBmb3IgZ2FzLW9ubHkgdXNlciBndWFyZHMuXFxcIlxcbiAgICAocmVxdWlyZS1jYXBhYmlsaXR5IChHQVMpKSlcXG5cXG4gIChkZWZ1biBnYXMtZ3VhcmQgKGd1YXJkOmd1YXJkKVxcbiAgICBcXFwiUHJlZGljYXRlIGZvciBnYXMgKyBzaW5nbGUga2V5IHVzZXIgZ3VhcmRzXFxcIlxcbiAgICAoZW5mb3JjZS1vbmVcXG4gICAgICBcXFwiRW5mb3JjZSBlaXRoZXIgdGhlIHByZXNlbmNlIG9mIGEgR0FTIGNhcCBvciBrZXlzZXRcXFwiXFxuICAgICAgWyAoZ2FzLW9ubHkpXFxuICAgICAgICAoZW5mb3JjZS1ndWFyZCBndWFyZClcXG4gICAgICBdKSlcXG5cXG4gIChkZWZ1biBidXktZ2FzOnN0cmluZyAoc2VuZGVyOnN0cmluZyB0b3RhbDpkZWNpbWFsKVxcbiAgICBAZG9jIFxcXCJUaGlzIGZ1bmN0aW9uIGRlc2NyaWJlcyB0aGUgbWFpbiAnZ2FzIGJ1eScgb3BlcmF0aW9uLiBBdCB0aGlzIHBvaW50IFxcXFxcXG4gICAgXFxcXE1JTkVSIGhhcyBiZWVuIGNob3NlbiBmcm9tIHRoZSBwb29sLCBhbmQgd2lsbCBiZSB2YWxpZGF0ZWQuIFRoZSBTRU5ERVIgICBcXFxcXFxuICAgIFxcXFxvZiB0aGlzIHRyYW5zYWN0aW9uIGhhcyBzcGVjaWZpZWQgYSBnYXMgbGltaXQgTElNSVQgKG1heGltdW0gZ2FzKSBmb3IgICAgXFxcXFxcbiAgICBcXFxcdGhlIHRyYW5zYWN0aW9uLCBhbmQgdGhlIHByaWNlIGlzIHRoZSBzcG90IHByaWNlIG9mIGdhcyBhdCB0aGF0IHRpbWUuICAgIFxcXFxcXG4gICAgXFxcXFRoZSBnYXMgYnV5IHdpbGwgYmUgZXhlY3V0ZWQgcHJpb3IgdG8gZXhlY3V0aW5nIFNFTkRFUidzIGNvZGUuXFxcIlxcblxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKD4gdG90YWwgMC4wKSlcXG4gICAgICAgICAgICAgKHByb3BlcnR5ICh2YWxpZC1hY2NvdW50IHNlbmRlcikpXFxuICAgICAgICAgICBdXFxuXFxuICAgICh2YWxpZGF0ZS1hY2NvdW50IHNlbmRlcilcXG5cXG4gICAgKGVuZm9yY2UtdW5pdCB0b3RhbClcXG4gICAgKGVuZm9yY2UgKD4gdG90YWwgMC4wKSBcXFwiZ2FzIHN1cHBseSBtdXN0IGJlIGEgcG9zaXRpdmUgcXVhbnRpdHlcXFwiKVxcblxcbiAgICAocmVxdWlyZS1jYXBhYmlsaXR5IChHQVMpKVxcbiAgICAod2l0aC1jYXBhYmlsaXR5IChERUJJVCBzZW5kZXIpXFxuICAgICAgKGRlYml0IHNlbmRlciB0b3RhbCkpXFxuICAgIClcXG5cXG4gIChkZWZ1biByZWRlZW0tZ2FzOnN0cmluZyAobWluZXI6c3RyaW5nIG1pbmVyLWd1YXJkOmd1YXJkIHNlbmRlcjpzdHJpbmcgdG90YWw6ZGVjaW1hbClcXG4gICAgQGRvYyBcXFwiVGhpcyBmdW5jdGlvbiBkZXNjcmliZXMgdGhlIG1haW4gJ3JlZGVlbSBnYXMnIG9wZXJhdGlvbi4gQXQgdGhpcyAgICBcXFxcXFxuICAgIFxcXFxwb2ludCwgdGhlIFNFTkRFUidzIHRyYW5zYWN0aW9uIGhhcyBiZWVuIGV4ZWN1dGVkLCBhbmQgdGhlIGdhcyB0aGF0ICAgICAgXFxcXFxcbiAgICBcXFxcd2FzIGNoYXJnZWQgaGFzIGJlZW4gY2FsY3VsYXRlZC4gTUlORVIgd2lsbCBiZSBjcmVkaXRlZCB0aGUgZ2FzIGNvc3QsICAgIFxcXFxcXG4gICAgXFxcXGFuZCBTRU5ERVIgd2lsbCByZWNlaXZlIHRoZSByZW1haW5kZXIgdXAgdG8gdGhlIGxpbWl0XFxcIlxcblxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKD4gdG90YWwgMC4wKSlcXG4gICAgICAgICAgICAgKHByb3BlcnR5ICh2YWxpZC1hY2NvdW50IHNlbmRlcikpXFxuICAgICAgICAgICAgIChwcm9wZXJ0eSAodmFsaWQtYWNjb3VudCBtaW5lcikpXFxuICAgICAgICAgICBdXFxuXFxuICAgICh2YWxpZGF0ZS1hY2NvdW50IHNlbmRlcilcXG4gICAgKHZhbGlkYXRlLWFjY291bnQgbWluZXIpXFxuICAgIChlbmZvcmNlLXVuaXQgdG90YWwpXFxuXFxuICAgIChyZXF1aXJlLWNhcGFiaWxpdHkgKEdBUykpXFxuICAgIChsZXQqXFxuICAgICAgKChmZWUgKHJlYWQtZGVjaW1hbCBcXFwiZmVlXFxcIikpXFxuICAgICAgIChyZWZ1bmQgKC0gdG90YWwgZmVlKSkpXFxuXFxuICAgICAgKGVuZm9yY2UtdW5pdCBmZWUpXFxuICAgICAgKGVuZm9yY2UgKD49IGZlZSAwLjApXFxuICAgICAgICBcXFwiZmVlIG11c3QgYmUgYSBub24tbmVnYXRpdmUgcXVhbnRpdHlcXFwiKVxcblxcbiAgICAgIChlbmZvcmNlICg-PSByZWZ1bmQgMC4wKVxcbiAgICAgICAgXFxcInJlZnVuZCBtdXN0IGJlIGEgbm9uLW5lZ2F0aXZlIHF1YW50aXR5XFxcIilcXG5cXG4gICAgICAoZW1pdC1ldmVudCAoVFJBTlNGRVIgc2VuZGVyIG1pbmVyIGZlZSkpIDt2M1xcblxcbiAgICAgICAgOyBkaXJlY3RseSB1cGRhdGUgaW5zdGVhZCBvZiBjcmVkaXRcXG4gICAgICAod2l0aC1jYXBhYmlsaXR5IChDUkVESVQgc2VuZGVyKVxcbiAgICAgICAgKGlmICg-IHJlZnVuZCAwLjApXFxuICAgICAgICAgICh3aXRoLXJlYWQgY29pbi10YWJsZSBzZW5kZXJcXG4gICAgICAgICAgICB7IFxcXCJiYWxhbmNlXFxcIiA6PSBiYWxhbmNlIH1cXG4gICAgICAgICAgICAodXBkYXRlIGNvaW4tdGFibGUgc2VuZGVyXFxuICAgICAgICAgICAgICB7IFxcXCJiYWxhbmNlXFxcIjogKCsgYmFsYW5jZSByZWZ1bmQpIH0pKVxcblxcbiAgICAgICAgICBcXFwibm9vcFxcXCIpKVxcblxcbiAgICAgICh3aXRoLWNhcGFiaWxpdHkgKENSRURJVCBtaW5lcilcXG4gICAgICAgIChpZiAoPiBmZWUgMC4wKVxcbiAgICAgICAgICAoY3JlZGl0IG1pbmVyIG1pbmVyLWd1YXJkIGZlZSlcXG4gICAgICAgICAgXFxcIm5vb3BcXFwiKSlcXG4gICAgICApXFxuXFxuICAgIClcXG5cXG4gIChkZWZ1biBjcmVhdGUtYWNjb3VudDpzdHJpbmcgKGFjY291bnQ6c3RyaW5nIGd1YXJkOmd1YXJkKVxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKHZhbGlkLWFjY291bnQgYWNjb3VudCkpIF1cXG5cXG4gICAgKHZhbGlkYXRlLWFjY291bnQgYWNjb3VudClcXG4gICAgKGVuZm9yY2UtcmVzZXJ2ZWQgYWNjb3VudCBndWFyZClcXG5cXG4gICAgKGluc2VydCBjb2luLXRhYmxlIGFjY291bnRcXG4gICAgICB7IFxcXCJiYWxhbmNlXFxcIiA6IDAuMFxcbiAgICAgICwgXFxcImd1YXJkXFxcIiAgIDogZ3VhcmRcXG4gICAgICB9KVxcbiAgICApXFxuXFxuICAoZGVmdW4gZ2V0LWJhbGFuY2U6ZGVjaW1hbCAoYWNjb3VudDpzdHJpbmcpXFxuICAgICh3aXRoLXJlYWQgY29pbi10YWJsZSBhY2NvdW50XFxuICAgICAgeyBcXFwiYmFsYW5jZVxcXCIgOj0gYmFsYW5jZSB9XFxuICAgICAgYmFsYW5jZVxcbiAgICAgIClcXG4gICAgKVxcblxcbiAgKGRlZnVuIGRldGFpbHM6b2JqZWN0e2Z1bmdpYmxlLXYyLmFjY291bnQtZGV0YWlsc31cXG4gICAgKCBhY2NvdW50OnN0cmluZyApXFxuICAgICh3aXRoLXJlYWQgY29pbi10YWJsZSBhY2NvdW50XFxuICAgICAgeyBcXFwiYmFsYW5jZVxcXCIgOj0gYmFsXFxuICAgICAgLCBcXFwiZ3VhcmRcXFwiIDo9IGcgfVxcbiAgICAgIHsgXFxcImFjY291bnRcXFwiIDogYWNjb3VudFxcbiAgICAgICwgXFxcImJhbGFuY2VcXFwiIDogYmFsXFxuICAgICAgLCBcXFwiZ3VhcmRcXFwiOiBnIH0pXFxuICAgIClcXG5cXG4gIChkZWZ1biByb3RhdGU6c3RyaW5nIChhY2NvdW50OnN0cmluZyBuZXctZ3VhcmQ6Z3VhcmQpXFxuICAgICh3aXRoLWNhcGFiaWxpdHkgKFJPVEFURSBhY2NvdW50KVxcbiAgICAgICh3aXRoLXJlYWQgY29pbi10YWJsZSBhY2NvdW50XFxuICAgICAgICB7IFxcXCJndWFyZFxcXCIgOj0gb2xkLWd1YXJkIH1cXG5cXG4gICAgICAgIChlbmZvcmNlLWd1YXJkIG9sZC1ndWFyZClcXG5cXG4gICAgICAgICh1cGRhdGUgY29pbi10YWJsZSBhY2NvdW50XFxuICAgICAgICAgIHsgXFxcImd1YXJkXFxcIiA6IG5ldy1ndWFyZCB9XFxuICAgICAgICAgICkpKVxcbiAgICApXFxuXFxuXFxuICAoZGVmdW4gcHJlY2lzaW9uOmludGVnZXJcXG4gICAgKClcXG4gICAgTUlOSU1VTV9QUkVDSVNJT04pXFxuXFxuICAoZGVmdW4gdHJhbnNmZXI6c3RyaW5nIChzZW5kZXI6c3RyaW5nIHJlY2VpdmVyOnN0cmluZyBhbW91bnQ6ZGVjaW1hbClcXG4gICAgQG1vZGVsIFsgKHByb3BlcnR5IGNvbnNlcnZlcy1tYXNzKVxcbiAgICAgICAgICAgICAocHJvcGVydHkgKD4gYW1vdW50IDAuMCkpXFxuICAgICAgICAgICAgIChwcm9wZXJ0eSAodmFsaWQtYWNjb3VudCBzZW5kZXIpKVxcbiAgICAgICAgICAgICAocHJvcGVydHkgKHZhbGlkLWFjY291bnQgcmVjZWl2ZXIpKVxcbiAgICAgICAgICAgICAocHJvcGVydHkgKCE9IHNlbmRlciByZWNlaXZlcikpIF1cXG5cXG4gICAgKGVuZm9yY2UgKCE9IHNlbmRlciByZWNlaXZlcilcXG4gICAgICBcXFwic2VuZGVyIGNhbm5vdCBiZSB0aGUgcmVjZWl2ZXIgb2YgYSB0cmFuc2ZlclxcXCIpXFxuXFxuICAgICh2YWxpZGF0ZS1hY2NvdW50IHNlbmRlcilcXG4gICAgKHZhbGlkYXRlLWFjY291bnQgcmVjZWl2ZXIpXFxuXFxuICAgIChlbmZvcmNlICg-IGFtb3VudCAwLjApXFxuICAgICAgXFxcInRyYW5zZmVyIGFtb3VudCBtdXN0IGJlIHBvc2l0aXZlXFxcIilcXG5cXG4gICAgKGVuZm9yY2UtdW5pdCBhbW91bnQpXFxuXFxuICAgICh3aXRoLWNhcGFiaWxpdHkgKFRSQU5TRkVSIHNlbmRlciByZWNlaXZlciBhbW91bnQpXFxuICAgICAgKGRlYml0IHNlbmRlciBhbW91bnQpXFxuICAgICAgKHdpdGgtcmVhZCBjb2luLXRhYmxlIHJlY2VpdmVyXFxuICAgICAgICB7IFxcXCJndWFyZFxcXCIgOj0gZyB9XFxuXFxuICAgICAgICAoY3JlZGl0IHJlY2VpdmVyIGcgYW1vdW50KSlcXG4gICAgICApXFxuICAgIClcXG5cXG4gIChkZWZ1biB0cmFuc2Zlci1jcmVhdGU6c3RyaW5nXFxuICAgICggc2VuZGVyOnN0cmluZ1xcbiAgICAgIHJlY2VpdmVyOnN0cmluZ1xcbiAgICAgIHJlY2VpdmVyLWd1YXJkOmd1YXJkXFxuICAgICAgYW1vdW50OmRlY2ltYWwgKVxcblxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgY29uc2VydmVzLW1hc3MpIF1cXG5cXG4gICAgKGVuZm9yY2UgKCE9IHNlbmRlciByZWNlaXZlcilcXG4gICAgICBcXFwic2VuZGVyIGNhbm5vdCBiZSB0aGUgcmVjZWl2ZXIgb2YgYSB0cmFuc2ZlclxcXCIpXFxuXFxuICAgICh2YWxpZGF0ZS1hY2NvdW50IHNlbmRlcilcXG4gICAgKHZhbGlkYXRlLWFjY291bnQgcmVjZWl2ZXIpXFxuXFxuICAgIChlbmZvcmNlICg-IGFtb3VudCAwLjApXFxuICAgICAgXFxcInRyYW5zZmVyIGFtb3VudCBtdXN0IGJlIHBvc2l0aXZlXFxcIilcXG5cXG4gICAgKGVuZm9yY2UtdW5pdCBhbW91bnQpXFxuXFxuICAgICh3aXRoLWNhcGFiaWxpdHkgKFRSQU5TRkVSIHNlbmRlciByZWNlaXZlciBhbW91bnQpXFxuICAgICAgKGRlYml0IHNlbmRlciBhbW91bnQpXFxuICAgICAgKGNyZWRpdCByZWNlaXZlciByZWNlaXZlci1ndWFyZCBhbW91bnQpKVxcbiAgICApXFxuXFxuICAoZGVmdW4gY29pbmJhc2U6c3RyaW5nIChhY2NvdW50OnN0cmluZyBhY2NvdW50LWd1YXJkOmd1YXJkIGFtb3VudDpkZWNpbWFsKVxcbiAgICBAZG9jIFxcXCJJbnRlcm5hbCBmdW5jdGlvbiBmb3IgdGhlIGluaXRpYWwgY3JlYXRpb24gb2YgY29pbnMuICBUaGlzIGZ1bmN0aW9uIFxcXFxcXG4gICAgXFxcXGNhbm5vdCBiZSB1c2VkIG91dHNpZGUgb2YgdGhlIGNvaW4gY29udHJhY3QuXFxcIlxcblxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKHZhbGlkLWFjY291bnQgYWNjb3VudCkpXFxuICAgICAgICAgICAgIChwcm9wZXJ0eSAoPiBhbW91bnQgMC4wKSlcXG4gICAgICAgICAgIF1cXG5cXG4gICAgKHZhbGlkYXRlLWFjY291bnQgYWNjb3VudClcXG4gICAgKGVuZm9yY2UtdW5pdCBhbW91bnQpXFxuXFxuICAgIChyZXF1aXJlLWNhcGFiaWxpdHkgKENPSU5CQVNFKSlcXG4gICAgKGVtaXQtZXZlbnQgKFRSQU5TRkVSIFxcXCJcXFwiIGFjY291bnQgYW1vdW50KSkgO3YzXFxuICAgICh3aXRoLWNhcGFiaWxpdHkgKENSRURJVCBhY2NvdW50KVxcbiAgICAgIChjcmVkaXQgYWNjb3VudCBhY2NvdW50LWd1YXJkIGFtb3VudCkpXFxuICAgIClcXG5cXG4gIChkZWZ1biByZW1lZGlhdGU6c3RyaW5nIChhY2NvdW50OnN0cmluZyBhbW91bnQ6ZGVjaW1hbClcXG4gICAgQGRvYyBcXFwiQWxsb3dzIGZvciByZW1lZGlhdGlvbiB0cmFuc2FjdGlvbnMuIFRoaXMgZnVuY3Rpb24gXFxcXFxcbiAgICAgICAgIFxcXFxpcyBwcm90ZWN0ZWQgYnkgdGhlIFJFTUVESUFURSBjYXBhYmlsaXR5XFxcIlxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKHZhbGlkLWFjY291bnQgYWNjb3VudCkpXFxuICAgICAgICAgICAgIChwcm9wZXJ0eSAoPiBhbW91bnQgMC4wKSlcXG4gICAgICAgICAgIF1cXG5cXG4gICAgKHZhbGlkYXRlLWFjY291bnQgYWNjb3VudClcXG5cXG4gICAgKGVuZm9yY2UgKD4gYW1vdW50IDAuMClcXG4gICAgICBcXFwiUmVtZWRpYXRpb24gYW1vdW50IG11c3QgYmUgcG9zaXRpdmVcXFwiKVxcblxcbiAgICAoZW5mb3JjZS11bml0IGFtb3VudClcXG5cXG4gICAgKHJlcXVpcmUtY2FwYWJpbGl0eSAoUkVNRURJQVRFKSlcXG4gICAgKGVtaXQtZXZlbnQgKFRSQU5TRkVSIFxcXCJcXFwiIGFjY291bnQgYW1vdW50KSkgO3YzXFxuICAgICh3aXRoLXJlYWQgY29pbi10YWJsZSBhY2NvdW50XFxuICAgICAgeyBcXFwiYmFsYW5jZVxcXCIgOj0gYmFsYW5jZSB9XFxuXFxuICAgICAgKGVuZm9yY2UgKDw9IGFtb3VudCBiYWxhbmNlKSBcXFwiSW5zdWZmaWNpZW50IGZ1bmRzXFxcIilcXG5cXG4gICAgICAodXBkYXRlIGNvaW4tdGFibGUgYWNjb3VudFxcbiAgICAgICAgeyBcXFwiYmFsYW5jZVxcXCIgOiAoLSBiYWxhbmNlIGFtb3VudCkgfVxcbiAgICAgICAgKSlcXG4gICAgKVxcblxcbiAgKGRlZnBhY3QgZnVuZC10eCAoc2VuZGVyOnN0cmluZyBtaW5lcjpzdHJpbmcgbWluZXItZ3VhcmQ6Z3VhcmQgdG90YWw6ZGVjaW1hbClcXG4gICAgQGRvYyBcXFwiJ2Z1bmQtdHgnIGlzIGEgc3BlY2lhbCBwYWN0IHRvIGZ1bmQgYSB0cmFuc2FjdGlvbiBpbiB0d28gc3RlcHMsICAgICBcXFxcXFxuICAgIFxcXFx3aXRoIHRoZSBhY3R1YWwgdHJhbnNhY3Rpb24gdHJhbnNwaXJpbmcgaW4gdGhlIG1pZGRsZTogICAgICAgICAgICAgICAgICAgXFxcXFxcbiAgICBcXFxcICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFxcXFxcXG4gICAgXFxcXCAgMSkgQSBidXlpbmcgcGhhc2UsIGRlYml0aW5nIHRoZSBzZW5kZXIgZm9yIHRvdGFsIGdhcyBhbmQgZmVlLCB5aWVsZGluZyBcXFxcXFxuICAgIFxcXFwgICAgIFRYX01BWF9DSEFSR0UuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXFxcXFxcbiAgICBcXFxcICAyKSBBIHNldHRsZW1lbnQgcGhhc2UsIHJlc3VtaW5nIFRYX01BWF9DSEFSR0UsIGFuZCBhbGxvY2F0aW5nIHRvIHRoZSAgIFxcXFxcXG4gICAgXFxcXCAgICAgY29pbmJhc2UgYWNjb3VudCBmb3IgdXNlZCBnYXMgYW5kIGZlZSwgYW5kIHNlbmRlciBhY2NvdW50IGZvciBiYWwtICBcXFxcXFxuICAgIFxcXFwgICAgIGFuY2UgKHVudXNlZCBnYXMsIGlmIGFueSkuXFxcIlxcblxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKD4gdG90YWwgMC4wKSlcXG4gICAgICAgICAgICAgKHByb3BlcnR5ICh2YWxpZC1hY2NvdW50IHNlbmRlcikpXFxuICAgICAgICAgICAgIChwcm9wZXJ0eSAodmFsaWQtYWNjb3VudCBtaW5lcikpXFxuICAgICAgICAgICAgIDsocHJvcGVydHkgY29uc2VydmVzLW1hc3MpIG5vdCBzdXBwb3J0ZWQgeWV0XFxuICAgICAgICAgICBdXFxuXFxuICAgIChzdGVwIChidXktZ2FzIHNlbmRlciB0b3RhbCkpXFxuICAgIChzdGVwIChyZWRlZW0tZ2FzIG1pbmVyIG1pbmVyLWd1YXJkIHNlbmRlciB0b3RhbCkpXFxuICAgIClcXG5cXG4gIChkZWZ1biBkZWJpdDpzdHJpbmcgKGFjY291bnQ6c3RyaW5nIGFtb3VudDpkZWNpbWFsKVxcbiAgICBAZG9jIFxcXCJEZWJpdCBBTU9VTlQgZnJvbSBBQ0NPVU5UIGJhbGFuY2VcXFwiXFxuXFxuICAgIEBtb2RlbCBbIChwcm9wZXJ0eSAoPiBhbW91bnQgMC4wKSlcXG4gICAgICAgICAgICAgKHByb3BlcnR5ICh2YWxpZC1hY2NvdW50IGFjY291bnQpKVxcbiAgICAgICAgICAgXVxcblxcbiAgICAodmFsaWRhdGUtYWNjb3VudCBhY2NvdW50KVxcblxcbiAgICAoZW5mb3JjZSAoPiBhbW91bnQgMC4wKVxcbiAgICAgIFxcXCJkZWJpdCBhbW91bnQgbXVzdCBiZSBwb3NpdGl2ZVxcXCIpXFxuXFxuICAgIChlbmZvcmNlLXVuaXQgYW1vdW50KVxcblxcbiAgICAocmVxdWlyZS1jYXBhYmlsaXR5IChERUJJVCBhY2NvdW50KSlcXG4gICAgKHdpdGgtcmVhZCBjb2luLXRhYmxlIGFjY291bnRcXG4gICAgICB7IFxcXCJiYWxhbmNlXFxcIiA6PSBiYWxhbmNlIH1cXG5cXG4gICAgICAoZW5mb3JjZSAoPD0gYW1vdW50IGJhbGFuY2UpIFxcXCJJbnN1ZmZpY2llbnQgZnVuZHNcXFwiKVxcblxcbiAgICAgICh1cGRhdGUgY29pbi10YWJsZSBhY2NvdW50XFxuICAgICAgICB7IFxcXCJiYWxhbmNlXFxcIiA6ICgtIGJhbGFuY2UgYW1vdW50KSB9XFxuICAgICAgICApKVxcbiAgICApXFxuXFxuXFxuICAoZGVmdW4gY3JlZGl0OnN0cmluZyAoYWNjb3VudDpzdHJpbmcgZ3VhcmQ6Z3VhcmQgYW1vdW50OmRlY2ltYWwpXFxuICAgIEBkb2MgXFxcIkNyZWRpdCBBTU9VTlQgdG8gQUNDT1VOVCBiYWxhbmNlXFxcIlxcblxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKD4gYW1vdW50IDAuMCkpXFxuICAgICAgICAgICAgIChwcm9wZXJ0eSAodmFsaWQtYWNjb3VudCBhY2NvdW50KSlcXG4gICAgICAgICAgIF1cXG5cXG4gICAgKHZhbGlkYXRlLWFjY291bnQgYWNjb3VudClcXG5cXG4gICAgKGVuZm9yY2UgKD4gYW1vdW50IDAuMCkgXFxcImNyZWRpdCBhbW91bnQgbXVzdCBiZSBwb3NpdGl2ZVxcXCIpXFxuICAgIChlbmZvcmNlLXVuaXQgYW1vdW50KVxcblxcbiAgICAocmVxdWlyZS1jYXBhYmlsaXR5IChDUkVESVQgYWNjb3VudCkpXFxuICAgICh3aXRoLWRlZmF1bHQtcmVhZCBjb2luLXRhYmxlIGFjY291bnRcXG4gICAgICB7IFxcXCJiYWxhbmNlXFxcIiA6IC0xLjAsIFxcXCJndWFyZFxcXCIgOiBndWFyZCB9XFxuICAgICAgeyBcXFwiYmFsYW5jZVxcXCIgOj0gYmFsYW5jZSwgXFxcImd1YXJkXFxcIiA6PSByZXRnIH1cXG4gICAgICA7IHdlIGRvbid0IHdhbnQgdG8gb3ZlcndyaXRlIGFuIGV4aXN0aW5nIGd1YXJkIHdpdGggdGhlIHVzZXItc3VwcGxpZWQgb25lXFxuICAgICAgKGVuZm9yY2UgKD0gcmV0ZyBndWFyZClcXG4gICAgICAgIFxcXCJhY2NvdW50IGd1YXJkcyBkbyBub3QgbWF0Y2hcXFwiKVxcblxcbiAgICAgIChsZXQgKChpcy1uZXdcXG4gICAgICAgICAgICAgKGlmICg9IGJhbGFuY2UgLTEuMClcXG4gICAgICAgICAgICAgICAgIChlbmZvcmNlLXJlc2VydmVkIGFjY291bnQgZ3VhcmQpXFxuICAgICAgICAgICAgICAgZmFsc2UpKSlcXG5cXG4gICAgICAgICh3cml0ZSBjb2luLXRhYmxlIGFjY291bnRcXG4gICAgICAgICAgeyBcXFwiYmFsYW5jZVxcXCIgOiAoaWYgaXMtbmV3IGFtb3VudCAoKyBiYWxhbmNlIGFtb3VudCkpXFxuICAgICAgICAgICwgXFxcImd1YXJkXFxcIiAgIDogcmV0Z1xcbiAgICAgICAgICB9KSlcXG4gICAgICApKVxcblxcbiAgKGRlZnVuIGNoZWNrLXJlc2VydmVkOnN0cmluZyAoYWNjb3VudDpzdHJpbmcpXFxuICAgIFxcXCIgQ2hlY2tzIEFDQ09VTlQgZm9yIHJlc2VydmVkIG5hbWUgYW5kIHJldHVybnMgdHlwZSBpZiBcXFxcXFxuICAgIFxcXFwgZm91bmQgb3IgZW1wdHkgc3RyaW5nLiBSZXNlcnZlZCBuYW1lcyBzdGFydCB3aXRoIGEgXFxcXFxcbiAgICBcXFxcIHNpbmdsZSBjaGFyIGFuZCBjb2xvbiwgZS5nLiAnYzpmb28nLCB3aGljaCB3b3VsZCByZXR1cm4gJ2MnIGFzIHR5cGUuXFxcIlxcbiAgICAobGV0ICgocGZ4ICh0YWtlIDIgYWNjb3VudCkpKVxcbiAgICAgIChpZiAoPSBcXFwiOlxcXCIgKHRha2UgLTEgcGZ4KSkgKHRha2UgMSBwZngpIFxcXCJcXFwiKSkpXFxuXFxuICAoZGVmdW4gZW5mb3JjZS1yZXNlcnZlZDpib29sIChhY2NvdW50OnN0cmluZyBndWFyZDpndWFyZClcXG4gICAgQGRvYyBcXFwiRW5mb3JjZSByZXNlcnZlZCBhY2NvdW50IG5hbWUgcHJvdG9jb2xzLlxcXCJcXG4gICAgKGxldCAoKHIgKGNoZWNrLXJlc2VydmVkIGFjY291bnQpKSlcXG4gICAgICAoaWYgKD0gXFxcIlxcXCIgcikgdHJ1ZVxcbiAgICAgICAgKGlmICg9IFxcXCJrXFxcIiByKVxcbiAgICAgICAgICAoZW5mb3JjZVxcbiAgICAgICAgICAgICg9IChmb3JtYXQgXFxcInt9XFxcIiBbZ3VhcmRdKVxcbiAgICAgICAgICAgICAgIChmb3JtYXQgXFxcIktleVNldCB7a2V5czogW3t9XSxwcmVkOiBrZXlzLWFsbH1cXFwiXFxuICAgICAgICAgICAgICAgICAgICAgICBbKGRyb3AgMiBhY2NvdW50KV0pKVxcbiAgICAgICAgICAgIFxcXCJTaW5nbGUta2V5IGFjY291bnQgcHJvdG9jb2wgdmlvbGF0aW9uXFxcIilcXG4gICAgICAgICAgKGVuZm9yY2UgZmFsc2VcXG4gICAgICAgICAgICAoZm9ybWF0IFxcXCJVbnJlY29nbml6ZWQgcmVzZXJ2ZWQgcHJvdG9jb2w6IHt9XFxcIiBbcl0pKSkpKSlcXG5cXG5cXG4gIChkZWZzY2hlbWEgY3Jvc3NjaGFpbi1zY2hlbWFcXG4gICAgQGRvYyBcXFwiU2NoZW1hIGZvciB5aWVsZGVkIHZhbHVlIGluIGNyb3NzLWNoYWluIHRyYW5zZmVyc1xcXCJcXG4gICAgcmVjZWl2ZXI6c3RyaW5nXFxuICAgIHJlY2VpdmVyLWd1YXJkOmd1YXJkXFxuICAgIGFtb3VudDpkZWNpbWFsKVxcblxcbiAgKGRlZnBhY3QgdHJhbnNmZXItY3Jvc3NjaGFpbjpzdHJpbmdcXG4gICAgKCBzZW5kZXI6c3RyaW5nXFxuICAgICAgcmVjZWl2ZXI6c3RyaW5nXFxuICAgICAgcmVjZWl2ZXItZ3VhcmQ6Z3VhcmRcXG4gICAgICB0YXJnZXQtY2hhaW46c3RyaW5nXFxuICAgICAgYW1vdW50OmRlY2ltYWwgKVxcblxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKD4gYW1vdW50IDAuMCkpXFxuICAgICAgICAgICAgIChwcm9wZXJ0eSAodmFsaWQtYWNjb3VudCBzZW5kZXIpKVxcbiAgICAgICAgICAgICAocHJvcGVydHkgKHZhbGlkLWFjY291bnQgcmVjZWl2ZXIpKVxcbiAgICAgICAgICAgXVxcblxcbiAgICAoc3RlcFxcbiAgICAgICh3aXRoLWNhcGFiaWxpdHkgKERFQklUIHNlbmRlcilcXG5cXG4gICAgICAgICh2YWxpZGF0ZS1hY2NvdW50IHNlbmRlcilcXG4gICAgICAgICh2YWxpZGF0ZS1hY2NvdW50IHJlY2VpdmVyKVxcblxcbiAgICAgICAgKGVuZm9yY2UgKCE9IFxcXCJcXFwiIHRhcmdldC1jaGFpbikgXFxcImVtcHR5IHRhcmdldC1jaGFpblxcXCIpXFxuICAgICAgICAoZW5mb3JjZSAoIT0gKGF0ICdjaGFpbi1pZCAoY2hhaW4tZGF0YSkpIHRhcmdldC1jaGFpbilcXG4gICAgICAgICAgXFxcImNhbm5vdCBydW4gY3Jvc3MtY2hhaW4gdHJhbnNmZXJzIHRvIHRoZSBzYW1lIGNoYWluXFxcIilcXG5cXG4gICAgICAgIChlbmZvcmNlICg-IGFtb3VudCAwLjApXFxuICAgICAgICAgIFxcXCJ0cmFuc2ZlciBxdWFudGl0eSBtdXN0IGJlIHBvc2l0aXZlXFxcIilcXG5cXG4gICAgICAgIChlbmZvcmNlLXVuaXQgYW1vdW50KVxcblxcbiAgICAgICAgOzsgc3RlcCAxIC0gZGViaXQgZGVsZXRlLWFjY291bnQgb24gY3VycmVudCBjaGFpblxcbiAgICAgICAgKGRlYml0IHNlbmRlciBhbW91bnQpXFxuXFxuICAgICAgICAoZW1pdC1ldmVudCAoVFJBTlNGRVIgc2VuZGVyIFxcXCJcXFwiIGFtb3VudCkpXFxuXFxuICAgICAgICAobGV0XFxuICAgICAgICAgICgoY3Jvc3NjaGFpbi1kZXRhaWxzOm9iamVjdHtjcm9zc2NoYWluLXNjaGVtYX1cXG4gICAgICAgICAgICB7IFxcXCJyZWNlaXZlclxcXCIgOiByZWNlaXZlclxcbiAgICAgICAgICAgICwgXFxcInJlY2VpdmVyLWd1YXJkXFxcIiA6IHJlY2VpdmVyLWd1YXJkXFxuICAgICAgICAgICAgLCBcXFwiYW1vdW50XFxcIiA6IGFtb3VudFxcbiAgICAgICAgICAgIH0pKVxcbiAgICAgICAgICAoeWllbGQgY3Jvc3NjaGFpbi1kZXRhaWxzIHRhcmdldC1jaGFpbilcXG4gICAgICAgICAgKSkpXFxuXFxuICAgIChzdGVwXFxuICAgICAgKHJlc3VtZVxcbiAgICAgICAgeyBcXFwicmVjZWl2ZXJcXFwiIDo9IHJlY2VpdmVyXFxuICAgICAgICAsIFxcXCJyZWNlaXZlci1ndWFyZFxcXCIgOj0gcmVjZWl2ZXItZ3VhcmRcXG4gICAgICAgICwgXFxcImFtb3VudFxcXCIgOj0gYW1vdW50XFxuICAgICAgICB9XFxuICAgICAgICAoZW1pdC1ldmVudCAoVFJBTlNGRVIgXFxcIlxcXCIgcmVjZWl2ZXIgYW1vdW50KSlcXG4gICAgICAgIDs7IHN0ZXAgMiAtIGNyZWRpdCBjcmVhdGUgYWNjb3VudCBvbiB0YXJnZXQgY2hhaW5cXG4gICAgICAgICh3aXRoLWNhcGFiaWxpdHkgKENSRURJVCByZWNlaXZlcilcXG4gICAgICAgICAgKGNyZWRpdCByZWNlaXZlciByZWNlaXZlci1ndWFyZCBhbW91bnQpKVxcbiAgICAgICAgKSlcXG4gICAgKVxcblxcblxcbiAgOyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLVxcbiAgOyBDb2luIGFsbG9jYXRpb25zXFxuXFxuICAoZGVmc2NoZW1hIGFsbG9jYXRpb24tc2NoZW1hXFxuICAgIEBkb2MgXFxcIkdlbmVzaXMgYWxsb2NhdGlvbiByZWdpc3RyeVxcXCJcXG4gICAgO0Btb2RlbCBbIChpbnZhcmlhbnQgKD49IGJhbGFuY2UgMC4wKSkgXVxcblxcbiAgICBiYWxhbmNlOmRlY2ltYWxcXG4gICAgZGF0ZTp0aW1lXFxuICAgIGd1YXJkOmd1YXJkXFxuICAgIHJlZGVlbWVkOmJvb2wpXFxuXFxuICAoZGVmdGFibGUgYWxsb2NhdGlvbi10YWJsZTp7YWxsb2NhdGlvbi1zY2hlbWF9KVxcblxcbiAgKGRlZnVuIGNyZWF0ZS1hbGxvY2F0aW9uLWFjY291bnRcXG4gICAgKCBhY2NvdW50OnN0cmluZ1xcbiAgICAgIGRhdGU6dGltZVxcbiAgICAgIGtleXNldC1yZWY6c3RyaW5nXFxuICAgICAgYW1vdW50OmRlY2ltYWxcXG4gICAgKVxcblxcbiAgICBAZG9jIFxcXCJBZGQgYW4gZW50cnkgdG8gdGhlIGNvaW4gYWxsb2NhdGlvbiB0YWJsZS4gVGhpcyBmdW5jdGlvbiBcXFxcXFxuICAgICAgICAgXFxcXGFsc28gY3JlYXRlcyBhIGNvcnJlc3BvbmRpbmcgZW1wdHkgY29pbiBjb250cmFjdCBhY2NvdW50IFxcXFxcXG4gICAgICAgICBcXFxcb2YgdGhlIHNhbWUgbmFtZSBhbmQgZ3VhcmQuIFJlcXVpcmVzIEdFTkVTSVMgY2FwYWJpbGl0eS4gXFxcIlxcblxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKHZhbGlkLWFjY291bnQgYWNjb3VudCkpIF1cXG5cXG4gICAgKHJlcXVpcmUtY2FwYWJpbGl0eSAoR0VORVNJUykpXFxuXFxuICAgICh2YWxpZGF0ZS1hY2NvdW50IGFjY291bnQpXFxuICAgIChlbmZvcmNlICg-PSBhbW91bnQgMC4wKVxcbiAgICAgIFxcXCJhbGxvY2F0aW9uIGFtb3VudCBtdXN0IGJlIG5vbi1uZWdhdGl2ZVxcXCIpXFxuXFxuICAgIChlbmZvcmNlLXVuaXQgYW1vdW50KVxcblxcbiAgICAobGV0XFxuICAgICAgKChndWFyZDpndWFyZCAoa2V5c2V0LXJlZi1ndWFyZCBrZXlzZXQtcmVmKSkpXFxuXFxuICAgICAgKGNyZWF0ZS1hY2NvdW50IGFjY291bnQgZ3VhcmQpXFxuXFxuICAgICAgKGluc2VydCBhbGxvY2F0aW9uLXRhYmxlIGFjY291bnRcXG4gICAgICAgIHsgXFxcImJhbGFuY2VcXFwiIDogYW1vdW50XFxuICAgICAgICAsIFxcXCJkYXRlXFxcIiA6IGRhdGVcXG4gICAgICAgICwgXFxcImd1YXJkXFxcIiA6IGd1YXJkXFxuICAgICAgICAsIFxcXCJyZWRlZW1lZFxcXCIgOiBmYWxzZVxcbiAgICAgICAgfSkpKVxcblxcbiAgKGRlZnVuIHJlbGVhc2UtYWxsb2NhdGlvblxcbiAgICAoIGFjY291bnQ6c3RyaW5nIClcXG5cXG4gICAgQGRvYyBcXFwiUmVsZWFzZSBmdW5kcyBhc3NvY2lhdGVkIHdpdGggYWxsb2NhdGlvbiBBQ0NPVU5UIGludG8gbWFpbiBsZWRnZXIuICAgXFxcXFxcbiAgICAgICAgIFxcXFxBQ0NPVU5UIG11c3QgYWxyZWFkeSBleGlzdCBpbiBtYWluIGxlZGdlci4gQWxsb2NhdGlvbiBpcyBkZWFjdGl2YXRlZCBcXFxcXFxuICAgICAgICAgXFxcXGFmdGVyIHJlbGVhc2UuXFxcIlxcbiAgICBAbW9kZWwgWyAocHJvcGVydHkgKHZhbGlkLWFjY291bnQgYWNjb3VudCkpIF1cXG5cXG4gICAgKHZhbGlkYXRlLWFjY291bnQgYWNjb3VudClcXG5cXG4gICAgKHdpdGgtcmVhZCBhbGxvY2F0aW9uLXRhYmxlIGFjY291bnRcXG4gICAgICB7IFxcXCJiYWxhbmNlXFxcIiA6PSBiYWxhbmNlXFxuICAgICAgLCBcXFwiZGF0ZVxcXCIgOj0gcmVsZWFzZS10aW1lXFxuICAgICAgLCBcXFwicmVkZWVtZWRcXFwiIDo9IHJlZGVlbWVkXFxuICAgICAgLCBcXFwiZ3VhcmRcXFwiIDo9IGd1YXJkXFxuICAgICAgfVxcblxcbiAgICAgIChsZXQgKChjdXJyLXRpbWU6dGltZSAoYXQgJ2Jsb2NrLXRpbWUgKGNoYWluLWRhdGEpKSkpXFxuXFxuICAgICAgICAoZW5mb3JjZSAobm90IHJlZGVlbWVkKVxcbiAgICAgICAgICBcXFwiYWxsb2NhdGlvbiBmdW5kcyBoYXZlIGFscmVhZHkgYmVlbiByZWRlZW1lZFxcXCIpXFxuXFxuICAgICAgICAoZW5mb3JjZVxcbiAgICAgICAgICAoPj0gY3Vyci10aW1lIHJlbGVhc2UtdGltZSlcXG4gICAgICAgICAgKGZvcm1hdCBcXFwiZnVuZHMgbG9ja2VkIHVudGlsIHt9LiBjdXJyZW50IHRpbWU6IHt9XFxcIiBbcmVsZWFzZS10aW1lIGN1cnItdGltZV0pKVxcblxcbiAgICAgICAgKHdpdGgtY2FwYWJpbGl0eSAoUkVMRUFTRV9BTExPQ0FUSU9OIGFjY291bnQgYmFsYW5jZSlcXG5cXG4gICAgICAgIChlbmZvcmNlLWd1YXJkIGd1YXJkKVxcblxcbiAgICAgICAgKHdpdGgtY2FwYWJpbGl0eSAoQ1JFRElUIGFjY291bnQpXFxuICAgICAgICAgIChlbWl0LWV2ZW50IChUUkFOU0ZFUiBcXFwiXFxcIiBhY2NvdW50IGJhbGFuY2UpKVxcbiAgICAgICAgICAoY3JlZGl0IGFjY291bnQgZ3VhcmQgYmFsYW5jZSlcXG5cXG4gICAgICAgICAgKHVwZGF0ZSBhbGxvY2F0aW9uLXRhYmxlIGFjY291bnRcXG4gICAgICAgICAgICB7IFxcXCJyZWRlZW1lZFxcXCIgOiB0cnVlXFxuICAgICAgICAgICAgLCBcXFwiYmFsYW5jZVxcXCIgOiAwLjBcXG4gICAgICAgICAgICB9KVxcblxcbiAgICAgICAgICBcXFwiQWxsb2NhdGlvbiBzdWNjZXNzZnVsbHkgcmVsZWFzZWQgdG8gbWFpbiBsZWRnZXJcXFwiKSlcXG4gICAgKSkpXFxuXFxuKVxcblwifX0sXCJzaWduZXJzXCI6W10sXCJtZXRhXCI6e1wiY3JlYXRpb25UaW1lXCI6MCxcInR0bFwiOjE3MjgwMCxcImdhc0xpbWl0XCI6MCxcImNoYWluSWRcIjpcIlwiLFwiZ2FzUHJpY2VcIjowLFwic2VuZGVyXCI6XCJcIn0sXCJub25jZVwiOlwiY29pbi1jb250cmFjdC12M1wifSJ9"
    ]
