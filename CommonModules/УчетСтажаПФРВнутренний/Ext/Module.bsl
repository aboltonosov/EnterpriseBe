﻿#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьДанныеВторичногоРегистра(МенеджерВременныхТаблиц, ИзмеренияОтбора = Неопределено, РежимЗагрузки = Ложь) Экспорт
	УчетСтажаПФРРасширенный.ОбновитьДанныеВторичногоРегистра(МенеджерВременныхТаблиц, ИзмеренияОтбора, РежимЗагрузки);	
КонецПроцедуры	

Функция РесурсыУчетаСтажаПФР() Экспорт
	Возврат УчетСтажаПФРРасширенный.РесурсыУчетаСтажаПФР();	
КонецФункции

Функция НоваяЗаписьНабораРегистраУчетаСтажаПФР(НаборЗаписей) Экспорт
	Возврат УчетСтажаПФРРасширенный.НоваяЗаписьНабораРегистраУчетаСтажаПФР(НаборЗаписей);	
КонецФункции

Функция ТекстДополнительныхПолейЗапросаВТДанныеУчетаСтажаПФР() Экспорт
	Возврат УчетСтажаПФРРасширенный.ТекстДополнительныхПолейЗапросаВТДанныеУчетаСтажаПФР();	
КонецФункции

Процедура СоздатьВТСоответствиеВидовСтажаПараметрамИсчисления2014(МенеджерВременныхТаблиц) Экспорт
	УчетСтажаПФРРасширенный.СоздатьВТСоответствиеВидовСтажаПараметрамИсчисления2014(МенеджерВременныхТаблиц);	
КонецПроцедуры	

Процедура СоздатьВТСоответствиеВидовСтажаПараметрамИсчисления2013(МенеджерВременныхТаблиц) Экспорт
	УчетСтажаПФРРасширенный.СоздатьВТСоответствиеВидовСтажаПараметрамИсчисления2013(МенеджерВременныхТаблиц);
КонецПроцедуры	

#КонецОбласти
