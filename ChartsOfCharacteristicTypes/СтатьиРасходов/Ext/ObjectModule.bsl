﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	 И ДанныеЗаполнения.Свойство("ВариантРаспределенияРасходов") Тогда
	 
		Если ДанныеЗаполнения.ВариантРаспределенияРасходов = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Склады");
		//++ НЕ УТ
		ИначеЕсли ДанныеЗаполнения.ВариантРаспределенияРасходов = Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
		//-- НЕ УТ
		ИначеЕсли ДанныеЗаполнения.ВариантРаспределенияРасходов = Перечисления.ВариантыРаспределенияРасходов.НаПрочиеАктивы Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ПрочиеРасходы");
			
		//++ НЕ УТ
		ИначеЕсли ДанныеЗаполнения.ВариантРаспределенияРасходов = Перечисления.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы Тогда
			
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ОбъектыЭксплуатации");
			КонтролироватьЗаполнениеАналитики = Истина;
		//-- НЕ УТ
		КонецЕсли;
	 
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ДоговорыКредитовИДепозитов") Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКредитовИДепозитов");
	КонецЕсли;
	
	Если ТипЗначения.Типы().Количество() > 1 Тогда
		ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Склады");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Предопределенный Тогда
		
		ПроверяемыеСтатьи = Новый Массив;
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.КурсовыеРазницы);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.НачисленныйНДСПриВыкупеМногооборотнойТары);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.ПрибыльУбытокПрошлыхЛет);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.СебестоимостьПродаж);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.ФормированиеРезервовПоСомнительнымДолгам);
		Если ПроверяемыеСтатьи.Найти(Ссылка) <> Неопределено
		 И ВариантРаспределенияРасходов <> Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности Тогда
			ТекстСообщения = НСтр("ru = 'Необходимо выбрать вариант распределения ""На направления деятельности""'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ВариантРаспределенияРасходов",
				,
				Отказ);
		КонецЕсли;
			
		Если Ссылка = ПланыВидовХарактеристик.СтатьиРасходов.НДСНалоговогоАгента
			И ВариантРаспределенияРасходов <> Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
			
			ТекстСообщения = НСтр("ru = 'Необходимо выбрать вариант распределения ""На себестоимость товаров""'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ВариантРаспределенияРасходов",
				,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если ВариантРаспределенияРасходов <> Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияНаСебестоимость");
	КонецЕсли;
	
	//++ НЕ УТ
	Если ВариантРаспределенияРасходов <> Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияПоЭтапамПроизводства");
		МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияПоПодразделениям");
	КонецЕсли;
	Если ВариантРаспределенияРасходов = Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты Тогда
		Если СпособРаспределенияНаПроизводственныеЗатраты <> Перечисления.СпособыРаспределенияСтатейРасходов.ПоПодразделениямИЭтапамПоПравилам Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияПоПодразделениям");
		КонецЕсли;
		Если СпособРаспределенияНаПроизводственныеЗатраты = Перечисления.СпособыРаспределенияСтатейРасходов.ПоЭтапамВручнуюПоВсемПодразделениям
			ИЛИ СпособРаспределенияНаПроизводственныеЗатраты = Перечисления.СпособыРаспределенияСтатейРасходов.НаДругиеСтатьиРасходов Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияПоЭтапамПроизводства");
		КонецЕсли;
	КонецЕсли;
	Если ВариантРаспределенияРасходов <> Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидАктива");
	КонецЕсли;
	
	// Предопределенные значения
	ВидРасходовНеУчитываемые = Перечисления.ВидыРасходовНУ.НеУчитываемыеВЦеляхНалогообложения;
	
	Если ЭтоГруппа Тогда
		
	// Вид расходов должен соответствовать флагу принятия к НУ
	ИначеЕсли Не ПринятиеКналоговомуУчету и Не ВидРасходов = ВидРасходовНеУчитываемые Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Вид расходов должен быть не принимаемым к налоговому учету.'"),
			ЭтотОбъект,
			"ВидРасходов",
			,
			Отказ);
		
	ИначеЕсли ПринятиеКналоговомуУчету и ВидРасходов = ВидРасходовНеУчитываемые Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Вид расходов должен быть принимаемым к налоговому учету.'"),
			ЭтотОбъект,
			"ВидРасходов",
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВариантРаспределенияРасходов <> Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов 
		ИЛИ НЕ ПринятиеКналоговомуУчету Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("ВидРБП"); 
	КонецЕсли;
	
	Если НЕ ПланыВидовХарактеристик.СтатьиРасходов.ВидРасходовИспользуется(ЭтотОбъект) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидРасходов"); 
	КонецЕсли;
	
	Если НЕ ПланыВидовХарактеристик.СтатьиРасходов.ВидПрочихРасходовИспользуется(ЭтотОбъект) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидПрочихРасходов"); 
	КонецЕсли;
	//-- НЕ УТ
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		Если ВариантРаспределенияРасходов <> Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности
			И ВариантРаспределенияРасходов <> Перечисления.ВариантыРаспределенияРасходов.НеРаспределять Тогда
			
			ВидДеятельностиРасходов = Перечисления.ВидыДеятельностиРасходов.ОсновнаяДеятельность;
			
		КонецЕсли;
		
		Если ВариантРаспределенияРасходов = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
			ВидЦенностиНДС = Перечисления.ВидыЦенностей.Товары;
		//++ НЕ УТ
		ИначеЕсли ВариантРаспределенияРасходов = Перечисления.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы Тогда
			Если ВидЦенностиНДС.Пустая() Тогда
				ВидЦенностиНДС = Перечисления.ВидыЦенностей.ОС
			КонецЕсли;
			
			Если ВидЦенностиНДС = Перечисления.ВидыЦенностей.ОС
			 Или ВидЦенностиНДС = Перечисления.ВидыЦенностей.ОбъектыНезавершенногоСтроительства Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ОбъектыЭксплуатации");
			ИначеЕсли ВидЦенностиНДС = Перечисления.ВидыЦенностей.НМА Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы");
				ВариантРаздельногоУчетаНДС = Перечисления.ВариантыРаздельногоУчетаНДС.Распределение;
			КонецЕсли;
		//-- НЕ УТ
		Иначе
			ВидЦенностиНДС = Перечисления.ВидыЦенностей.ПрочиеРаботыИУслуги;
		КонецЕсли;
		
		ПрочиеРасходы = ТипЗначения.СодержитТип(Тип("СправочникСсылка.ПрочиеРасходы"));
		ДоговорыКредитовИДепозитов = ТипЗначения.СодержитТип(Тип("СправочникСсылка.ДоговорыКредитовИДепозитов"));
		//++ НЕ УТ
		РасходыНаОбъектыЭксплуатации = (ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОбъектыЭксплуатации")));
		РасходыНаНМАиНИОКР = (ТипЗначения.СодержитТип(Тип("СправочникСсылка.НематериальныеАктивы")));
		//-- НЕ УТ
		
		Если Не ПустаяСтрока(КорреспондирующийСчет) Тогда
			Если ПустаяСтрока(СтрЗаменить(КорреспондирующийСчет, ".", "")) Тогда
				КорреспондирующийСчет = "";
			Иначе
				Пока Прав(СокрЛП(КорреспондирующийСчет), 1) = "." Цикл
					КорреспондирующийСчет = Лев(СокрЛП(КорреспондирующийСчет), СтрДлина(СокрЛП(КорреспондирующийСчет)) - 1);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ОграничитьИспользование
			И ДоступныеХозяйственныеОперации.Количество() > 0 Тогда
			
			ДоступныеХозяйственныеОперации.Очистить();
			ДоступныеОперации = "";
		Иначе
			СписокОпераций = Новый СписокЗначений;
			ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьСписокХозяйственныхОпераций(СписокОпераций);
			СтрокаДоступныеОперации = "";
			Для Каждого СтрокаТаблицы Из ДоступныеХозяйственныеОперации Цикл
				ЭлементСписка = СписокОпераций.НайтиПоЗначению(СтрокаТаблицы.ХозяйственнаяОперация);
				Если ЭлементСписка <> Неопределено Тогда
					СтрокаДоступныеОперации = СтрокаДоступныеОперации
						+ ?(Не ПустаяСтрока(СтрокаДоступныеОперации), ", ", "")
						+ ЭлементСписка.Представление;
				КонецЕсли;
			КонецЦикла;
			Если ДоступныеОперации <> СтрокаДоступныеОперации Тогда
				ДоступныеОперации = СтрокаДоступныеОперации;
			КонецЕсли;
		КонецЕсли;
		
		//++ НЕ УТ
		Если ВариантРаспределенияРасходов = Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов Тогда
			ПринятиеКналоговомуУчету = Истина;
		КонецЕсли;
		
		Если Не ПринятиеКналоговомуУчету 
			И ВидРасходов.Пустая()
			И ПланыВидовХарактеристик.СтатьиРасходов.ВидРасходовИспользуется(ЭтотОбъект) Тогда
			ВидРасходов = Перечисления.ВидыРасходовНУ.НеУчитываемыеВЦеляхНалогообложения;
		КонецЕсли;
		//-- НЕ УТ
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		ВидыСчетаДляОчистки = Новый Массив;
		Если ЗначениеЗаполнено(СчетУчета) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.Расходы);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетСписанияОСНО) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.СписаниеРасходовОСНО);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетСписанияЕНВД) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.СписаниеРасходовЕНВД);
		КонецЕсли;
		Если ВидыСчетаДляОчистки.Количество() Тогда
			РегистрыСведений.СчетаРеглУчетаТребующиеНастройки.ОчиститьПриЗаписиАналитикиУчета(Ссылка, ВидыСчетаДляОчистки);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
