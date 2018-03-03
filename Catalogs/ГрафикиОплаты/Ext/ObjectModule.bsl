﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Этапы.Итог("ПроцентПлатежа") <> 100 Тогда
		
		ТекстОшибки = НСтр("ru='Процент платежей по всем этапам должен быть равен 100%'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Этапы",
			,
			Отказ);
		
	КонецЕсли;
	
	Если Этапы.Итог("ПроцентЗалогаЗаТару") <> 100 И Этапы.Итог("ПроцентЗалогаЗаТару") <> 0 Тогда
		
		ТекстОшибки = НСтр("ru='Процент залога за тару по всем этапам должен быть равен 100% или 0%'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Этапы",
			,
			Отказ);
		
	КонецЕсли;
	
	КоличествоЭтапов = Этапы.Количество();
	
	Если КоличествоЭтапов >= 2 Тогда
		
		Для ВнешнийСчетчик = 2 По КоличествоЭтапов Цикл
			
			ИндексПредыдущегоЭтапа           = ВнешнийСчетчик - 2;
			ИндексТекущегоЭтапа              = ВнешнийСчетчик - 1;
			ПредыдущееЗначениеВариантаОплаты = Этапы[ИндексПредыдущегоЭтапа].ВариантОплаты;
			ПредыдущееЗначениеСдвига         = Этапы[ИндексПредыдущегоЭтапа].Сдвиг;
			ТекущееЗначениеВариантаОплаты    = Этапы[ИндексТекущегоЭтапа].ВариантОплаты;
			ТекущееЗначениеСдвига            = Этапы[ИндексТекущегоЭтапа].Сдвиг;
			
			// В табличной части Этапы не должно быть строк со значением АвансДоОбеспечения
			// в поле ВариантОплаты, идущих после строк со значением ПредоплатаДоОтгрузки
			// КредитПослеОтгрузки
			Если (ТекущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения И 
				(ПредыдущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки Или
				 ПредыдущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки)) Или
				// В табличной части Этапы не должно быть строк со значением ПредоплатаДоОтгрузки
				// в поле ВариантОплаты, идущих после строк со значением КредитПослеОтгрузки
				(ТекущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки И 
				ПредыдущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки) Тогда
				
				ТекстОшибки = НСтр("ru='Вариант оплаты ""%ТекущееЗначениеВариантаОплаты%"" в строке %ИндексТекущегоЭтапа%
				|не может идти после варианта оплаты ""%ПредыдущееЗначениеВариантаОплаты%"" в строке %ИндексПредыдущегоЭтапа%'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ПредыдущееЗначениеВариантаОплаты%", ПредыдущееЗначениеВариантаОплаты);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ТекущееЗначениеВариантаОплаты%",    ТекущееЗначениеВариантаОплаты);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ИндексТекущегоЭтапа%",              ИндексТекущегоЭтапа + 1);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ИндексПредыдущегоЭтапа%",           ИндексПредыдущегоЭтапа + 1);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Этапы",ИндексТекущегоЭтапа+1,"ВариантОплаты"),
					,
					Отказ);
			
			КонецЕсли;
			
			// Значение поля Сдвиг табличной части Этапы должно идти по возрастанию для 
			// вариантов оплаты Аванс (АвансДоОбеспечения, ПредоплатаДоОтгрузки) и Кредит 
			// (КредитПослеОтгрузки). Это необходимо для того, чтобы при заполнении 
			// фактического графика в документе продажи в строках не оказалось дат, 
			// превышающих значения дат в последующих строках.
			Если (((ТекущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения Или
				ТекущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки) И 
				(ПредыдущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения Или
				ТекущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки)) Или
				(ТекущееЗначениеВариантаОплаты = Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки И 
				ПредыдущееЗначениеВариантаОплаты = ТекущееЗначениеВариантаОплаты)) И
				ТекущееЗначениеСдвига < ПредыдущееЗначениеСдвига Тогда
				
				ТекстОшибки = НСтр("ru='Отсрочка в строке %ИндексТекущегоЭтапа% 
				| должна быть не меньше, чем в строке %ИндексПредыдущегоЭтапа%'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ИндексТекущегоЭтапа%",    ИндексТекущегоЭтапа + 1);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ИндексПредыдущегоЭтапа%", ИндексПредыдущегоЭтапа + 1);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Этапы",ИндексТекущегоЭтапа+1,"Сдвиг"),
					,
					Отказ);
			
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("Этапы.ПроцентПлатежа");
	НепроверяемыеРеквизиты.Добавить("Этапы.ПроцентЗалогаЗаТару");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	Для Каждого ЭтапОплаты Из Этапы Цикл
		
		Если Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентПлатежа) И Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентЗалогаЗаТару) Тогда
			
			ТекстОшибки = НСтр("ru='В строке для этапа должен быть указан процент платежа или процент залога за тару'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Этапы[" + ЭтапОплаты.НомерСтроки + "]",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Проверим наличие только кредитных этапов оплаты в графике.
	ТолькоКредитныеЭтапыВГрафике = Истина;
	Для Каждого СтрокаТаблицы Из Этапы Цикл
		Если СтрокаТаблицы.ВариантОплаты <> Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки Тогда
			ТолькоКредитныеЭтапыВГрафике = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ТолькоКредитныеЭтапы <> ТолькоКредитныеЭтапыВГрафике Тогда
		ТолькоКредитныеЭтапы = ТолькоКредитныеЭтапыВГрафике;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
