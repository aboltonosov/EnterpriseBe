﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура загружает XML файл в информационную базу.
//
// Параметры:
//    Объект - ЛюбаяСсылка - Не используется
//    XMLФайл - ЛюбаяСсылка - Не используется
//    ПроводитьДокументыПриЗагрузке - Булево - Признак необходимости проведения документов при загрузке в ИБ
//    СтатьяРасходов - ПланВидовХарактеристикСсылка - Статья расхода, на которую бедет отнесена комиссия банка
//    АналитикаРасходов - ЛюбаяСсылка - Аналитика расхода
//    Подразделение - СправочникСсылка - Подразделение, на которое относятся расходы
//    Адрес - Строка - Адрес во временном хранилище
//
Процедура ЗагрузитьXMLФайлВИнформационнуюБазуСервер(Объект, XMLФайл, ПроводитьДокументыПриЗагрузке, СтатьяРасходов, АналитикаРасходов, Подразделение, Адрес) Экспорт
	
	ДеревоЗначенийXMLФайл = Новый ДеревоЗначений;
	ДеревоЗначенийXMLФайл.Колонки.Добавить("ИмяЭлемента");
	ДеревоЗначенийXMLФайл.Колонки.Добавить("ЗначениеЭлемента");
	
	Если ПрочитатьXMLФайлВДеревоЗначений(Объект, XMLФайл, ДеревоЗначенийXMLФайл, Адрес) Тогда
		
		Если ДеревоЗначенийXMLФайл.Строки.Количество() > 0 Тогда
			
			Если ДеревоЗначенийXMLФайл.Строки.Найти("СтрокаПоМерчанту", "ИмяЭлемента", Истина) = Неопределено Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='В файле с данными не найден элемент с наименованием ""СтрокаПоМерчанту""!
					|Формат выбранного файла не соответствует поддерживаемому формату.'"), , "XMLФайл");
				
			Иначе
				
				ЗагрузитьXMLФайлИзДереваЗначенийВИнформационнуюБазу(
					ДеревоЗначенийXMLФайл.Строки,
					ПроводитьДокументыПриЗагрузке,
					СтатьяРасходов,
					АналитикаРасходов,
					Подразделение);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура СоздатьДокументОтчетБанкаПоОперациямЭквайринга(Элементы, НомерОтчета, ПроводитьДокументыПриЗагрузке, СтатьяРасходов, АналитикаРасходов, Подразделение, АтрибутыЭлементаДанныеПоЗапросу)
	
	НомерСтрокиПоТерминалу = 0;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ЭквайринговыеТерминалы.Ссылка КАК ЭквайринговыйТерминал,
	|	ЭквайринговыеТерминалы.БанковскийСчет КАК БанковскийСчет,
	|	ЭквайринговыеТерминалы.БанковскийСчет.Владелец КАК Организация,
	|	ЭквайринговыеТерминалы.БанковскийСчет.ВалютаДенежныхСредств КАК Валюта,
	|	ЭквайринговыеТерминалы.Эквайер КАК Эквайер
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	ЭквайринговыеТерминалы.Код = &Код
	|");
	
	Если ПроводитьДокументыПриЗагрузке Тогда
		РежимЗаписиДок = РежимЗаписиДокумента.Проведение;
	Иначе
		РежимЗаписиДок = РежимЗаписиДокумента.Запись;
	КонецЕсли;
	
	ОбъектДокументаОтчетБанкаПоОперациямЭквайринга = Документы["ОтчетБанкаПоОперациямЭквайринга"].СоздатьДокумент();
	
	СуммаКомиссии = 0;
	
	Для Каждого Элемент Из Элементы Цикл
		
		Если Элемент.ИмяЭлемента = "Дата" Тогда
				
			Попытка
				
				Если КонецДня(СтрЗаменить(Элемент.ЗначениеЭлемента, "-", "")) = КонецДня(ТекущаяДата()) Тогда
					
					ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Дата =
						СтрЗаменить(Элемент.ЗначениеЭлемента, "-", "") +
						Формат(Час(ТекущаяДата()), "ЧЦ=2; ЧВН=") +
						Формат(Минута(ТекущаяДата()), "ЧЦ=2; ЧВН=") +
						Формат(Секунда(ТекущаяДата()), "ЧЦ=2; ЧВН=");
					
				Иначе
					
					ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Дата =
						СтрЗаменить(Элемент.ЗначениеЭлемента, "-", "") + "120000";
					
				КонецЕсли;
				
			Исключение
				
				ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Дата = Неопределено;
				
			КонецПопытки;
			
		ИначеЕсли Элемент.ИмяЭлемента = "НомерМерчанта" Тогда
			
			Если ЗначениеЗаполнено(Элемент.ЗначениеЭлемента)
			   И СтрДлина(Элемент.ЗначениеЭлемента) <= 11  Тогда
				
				Попытка
					
					ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Номер = Элемент.ЗначениеЭлемента;
					
				Исключение
					
					ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Номер = "";
					
				КонецПопытки;
				
			КонецЕсли;
		
		ИначеЕсли Элемент.ИмяЭлемента = "СтрокаПоТерминалу" Тогда
			
			НомерСтрокиПоТерминалу = НомерСтрокиПоТерминалу + 1;
			
			СтрокаПоТерминалу = Новый Структура;
			
			Для Каждого СтрокаТабличнойЧасти Из Элемент.Строки Цикл
				
				СтрокаПоТерминалу.Вставить(СтрокаТабличнойЧасти.ИмяЭлемента, СтрокаТабличнойЧасти.ЗначениеЭлемента);
				
			КонецЦикла;
			
			Знч = Неопределено;
			
			Если СтрокаПоТерминалу.Свойство("ТипОперации", Знч) Тогда
				
				Если НЕ ЗначениеЗаполнено(Знч) Тогда
					
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не указан тип операции. Элемент ""СтрокаПоТерминалу"" №%2 не загружен!'"), НомерОтчета, НомерСтрокиПоТерминалу);
					Сообщение.Сообщить();
					
					Продолжить;
					
				ИначеЕсли ВРег(СокрЛП(Знч)) = ВРег("оплата") Тогда
					СтрТаблЧасть = ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Покупки.Добавить();
				ИначеЕсли ВРег(СокрЛП(Знч)) = ВРег("возврат")
					  ИЛИ ВРег(СокрЛП(Знч)) = ВРег("отмена") Тогда
					СтрТаблЧасть = ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Возвраты.Добавить();
				Иначе
					Продолжить;
				КонецЕсли;
				
			Иначе
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст =
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не найден элемент ""ТипОперации"". Элемент ""СтрокаПоТерминалу"" №%2 не загружен!'"),
						НомерОтчета,
						НомерСтрокиПоТерминалу);
				Сообщение.Сообщить();
				
				Продолжить;
				
			КонецЕсли;
			
			Если СтрокаПоТерминалу.Свойство("НомерТерминала", Знч) Тогда
				
				Если НЕ ЗначениеЗаполнено(Знч) Тогда
					
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст =
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не указан номер терминала!'"), НомерОтчета, НомерСтрокиПоТерминалу);
					Сообщение.Сообщить();
					
					РежимЗаписиДок = РежимЗаписиДокумента.Запись;
					
				Иначе
					
					Запрос.УстановитьПараметр("Код", СокрЛП(СтрокаПоТерминалу.НомерТерминала));
	
					Выборка = Запрос.Выполнить().Выбрать();
					Если Выборка.Следующий() Тогда
						
						СтрТаблЧасть.ЭквайринговыйТерминал = Выборка.ЭквайринговыйТерминал;
						
						Если ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.БанковскийСчет.Ссылка.Пустая()
							Или ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Эквайер.Ссылка.Пустая() Тогда
							
							ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.БанковскийСчет    = Выборка.БанковскийСчет;
							ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Эквайер           = Выборка.Эквайер;
							ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Организация       = Выборка.Организация;
							ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Валюта            = Выборка.Валюта;
							
							Если НЕ АтрибутыЭлементаДанныеПоЗапросу.ИНН = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Организация, "ИНН") Тогда
								
								ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
									НСтр("ru='В отчете банка по операциям эквайринга идентификационный номер налогоплательщика (ИНН) не соответствует идентификационному номеру налогоплательщика договора эквайринга в информационной базе!'"));
								
								РежимЗаписиДок = РежимЗаписиДокумента.Запись;
								
							КонецЕсли;	
								
							Если НЕ АтрибутыЭлементаДанныеПоЗапросу.БИК = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.БанковскийСчет.Банк, "Код") Тогда
								
								ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
									НСтр("ru='В отчете банка по операциям эквайринга банковский идентификационный код (БИК) не соответствует банковскому идентификационному коду договора эквайринга в информационной базе!'"));
								
								РежимЗаписиДок = РежимЗаписиДокумента.Запись;
								
							КонецЕсли;	
								
							Если НЕ АтрибутыЭлементаДанныеПоЗапросу.РасчетныйСчетОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.БанковскийСчет, "НомерСчета") Тогда
								
								ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
									НСтр("ru='В отчете банка по операциям эквайринга не указан расчетный счет организации или не соответствует расчетному счету организации договора эквайринга в информационной базе!'"));
								
								РежимЗаписиДок = РежимЗаписиДокумента.Запись;
								
							КонецЕсли;
							
						КонецЕсли;
						
					Иначе
						
						Сообщение = Новый СообщениеПользователю;
						Сообщение.Текст =
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='В информационной базе не найден эквайринговый терминал с кодом %1!'"),
								СокрЛП(СтрокаПоТерминалу.НомерТерминала));
						Сообщение.Сообщить();
						
						РежимЗаписиДок = РежимЗаписиДокумента.Запись;
						
					КонецЕсли;
					
				КонецЕсли;
				
			Иначе
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не найден элемент ""НомерТерминала""!'"), НомерОтчета, НомерСтрокиПоТерминалу);
				Сообщение.Сообщить();
				
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				
			КонецЕсли;
			
			Если СтрокаПоТерминалу.Свойство("ВремяОперации", Знч) Тогда
				
				Если НЕ ЗначениеЗаполнено(Знч) Тогда
					
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не указано время операции!'"), НомерОтчета, НомерСтрокиПоТерминалу);
					Сообщение.Сообщить();
					
					РежимЗаписиДок = РежимЗаписиДокумента.Запись;
					
				Иначе
					СтрТаблЧасть.ДатаПлатежа = СтрЗаменить(Лев(СтрокаПоТерминалу.ВремяОперации, 10), "-", "");
				КонецЕсли;
				
			Иначе
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не найден элемент ""ВремяОперации""!'"), НомерОтчета, НомерСтрокиПоТерминалу);
				Сообщение.Сообщить();
				
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				
			КонецЕсли;
			
			Если СтрокаПоТерминалу.Свойство("СуммаОперации", Знч) Тогда
				
				Если НЕ ЗначениеЗаполнено(Знч) Тогда
					
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не указана сумма операции!'"), НомерОтчета, НомерСтрокиПоТерминалу);
					Сообщение.Сообщить();
					
					РежимЗаписиДок = РежимЗаписиДокумента.Запись;
					
				Иначе
					
					Если Число(СтрокаПоТерминалу.СуммаОперации) < 0 Тогда
						СтрТаблЧасть.Сумма = Строка((-1) * Число(СтрокаПоТерминалу.СуммаОперации));
					Иначе
						СтрТаблЧасть.Сумма = СтрокаПоТерминалу.СуммаОперации;
					КонецЕсли;
					
				КонецЕсли;
				
			Иначе
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не найден элемент ""СуммаОперации""!'"),
						НомерОтчета,
						НомерСтрокиПоТерминалу);
				Сообщение.Сообщить();
				
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				
			КонецЕсли;
			
			Если СтрокаПоТерминалу.Свойство("НомерКарты", Знч) Тогда
				
				Если НЕ ЗначениеЗаполнено(Знч) Тогда
					
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не указан номер карты!'"),
						НомерОтчета,
						НомерСтрокиПоТерминалу);
					Сообщение.Сообщить();
					
					РежимЗаписиДок = РежимЗаписиДокумента.Запись;
					
				Иначе
					СтрТаблЧасть.НомерПлатежнойКарты = СтрокаПоТерминалу.НомерКарты;
				КонецЕсли;
				
			Иначе
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не найден элемент ""НомерКарты""!'"),
					НомерОтчета,
					НомерСтрокиПоТерминалу);
				Сообщение.Сообщить();
				
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				
			КонецЕсли;
			
			СтрокаПоТерминалу.Свойство("КодАвторизации", СтрТаблЧасть.КодАвторизации);
			
			Если СтрокаПоТерминалу.Свойство("Валюта", Знч) Тогда
				
				СтрокаПоТерминалуВалюта = СтрокаПоТерминалу.Валюта;
				// Заменяем код валюты, т.к. согласно положению о безналичных расчетах валюте "Рубль" соответствует код 810,
				// а согласно классификатору валют код у рубля другой - 643.
				Если СтрокаПоТерминалуВалюта = "810" Тогда
					СтрокаПоТерминалуВалюта = "643";
				КонецЕсли;
								
				Если ЗначениеЗаполнено(Знч)
				   И ЗначениеЗаполнено(ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.БанковскийСчет)
				   И НЕ ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Валюта = ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Валюта.Ссылка.Пустая()
				   И НЕ СокрЛП(СтрокаПоТерминалуВалюта) = СокрЛП(ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Валюта.Код)
				   И НЕ СокрЛП(СтрокаПоТерминалуВалюта) = СокрЛП(ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Валюта.Наименование) Тогда
					
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) код валюты не соответствует коду валюты банковского счета!'"), НомерОтчета, НомерСтрокиПоТерминалу);
					Сообщение.Сообщить();
					
					РежимЗаписиДок = РежимЗаписиДокумента.Запись;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если СтрокаПоТерминалу.Свойство("Комиссия", Знч) Тогда
				
				Если ЗначениеЗаполнено(Знч) Тогда
					
					Если ВРег(СокрЛП(СтрокаПоТерминалу.ТипОперации)) = ВРег("оплата") Тогда
						СуммаКомиссии = СуммаКомиссии + СтрокаПоТерминалу.Комиссия;
					ИначеЕсли ВРег(СокрЛП(СтрокаПоТерминалу.ТипОперации)) = ВРег("возврат")
						  ИЛИ ВРег(СокрЛП(СтрокаПоТерминалу.ТипОперации)) = ВРег("отмена") Тогда
						СуммаКомиссии = СуммаКомиссии - СтрокаПоТерминалу.Комиссия;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли Элемент.ИмяЭлемента = "КонтрольнаяСуммаПоДате" Тогда
			
			КоличествоЗаписейОплата  = 0;
			КоличествоЗаписейВозврат = 0;
			СуммаИтогоОплата         = 0;
			СуммаИтогоВозврат        = 0;
			
			Для Каждого ЭлементКонтрольнойСуммыПоДате Из Элемент.Строки Цикл
				
				Если ЭлементКонтрольнойСуммыПоДате.ИмяЭлемента = "Дата" Тогда
					
					Если НЕ КонецДня(СтрЗаменить(ЭлементКонтрольнойСуммыПоДате.ЗначениеЭлемента, "-", "")) = КонецДня(ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Дата) Тогда
						
						Сообщение = Новый СообщениеПользователю;
						Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) дата в элементе ""КонтрольнаяСуммаПоДате"" не соответствует дате операции!'"),
							НомерОтчета);
						Сообщение.Сообщить();
						
						РежимЗаписиДок = РежимЗаписиДокумента.Запись;
						
						Прервать;
						
					КонецЕсли;
				
				ИначеЕсли ЭлементКонтрольнойСуммыПоДате.ИмяЭлемента = "Операция" Тогда
					
					Если ВРег(СокрЛП(ЭлементКонтрольнойСуммыПоДате.Строки[0].ЗначениеЭлемента)) = ВРег("оплата") Тогда
						
						КоличествоЗаписейОплата = КоличествоЗаписейОплата + ЭлементКонтрольнойСуммыПоДате.Строки[1].ЗначениеЭлемента;
						СуммаИтогоОплата        = СуммаИтогоОплата + ЭлементКонтрольнойСуммыПоДате.Строки[2].ЗначениеЭлемента;
						
					ИначеЕсли ВРег(СокрЛП(ЭлементКонтрольнойСуммыПоДате.Строки[0].ЗначениеЭлемента)) = ВРег("возврат")
						  ИЛИ ВРег(СокрЛП(ЭлементКонтрольнойСуммыПоДате.Строки[0].ЗначениеЭлемента)) = ВРег("отмена") Тогда
						
						КоличествоЗаписейВозврат = КоличествоЗаписейВозврат + ЭлементКонтрольнойСуммыПоДате.Строки[1].ЗначениеЭлемента;
						СуммаИтогоВозврат        = СуммаИтогоВозврат + ЭлементКонтрольнойСуммыПоДате.Строки[2].ЗначениеЭлемента;
						
					КонецЕсли;
					
				КонецЕсли;
			
			КонецЦикла;
			
			Если НЕ КоличествоЗаписейОплата = ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Покупки.Количество() Тогда
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) количество записей по оплате в элементе ""КонтрольнаяСуммаПоДате"" не соответствует количеству операций по оплате!'"),
					НомерОтчета);
				Сообщение.Сообщить();
				
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				
			КонецЕсли;
			
			Если НЕ СуммаИтогоОплата = ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Покупки.Итог("Сумма") Тогда
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) итоговая сумма по оплате в элементе ""КонтрольнаяСуммаПоДате"" не соответствует итоговой сумме операций по оплате!'"),
					НомерОтчета);
				Сообщение.Сообщить();
				
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				
			КонецЕсли;
			
			Если НЕ КоличествоЗаписейВозврат = ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Возвраты.Количество() Тогда
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) количество записей по возврату и по отмене в элементе ""КонтрольнаяСуммаПоДате"" не соответствует количеству операций по возврату!'"),
					НомерОтчета);
				Сообщение.Сообщить();
				
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				
			КонецЕсли;
			
			Если НЕ СуммаИтогоВозврат = ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Возвраты.Итог("Сумма") Тогда
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) итоговая сумма по возврату и по отмене в элементе ""КонтрольнаяСуммаПоДате"" не соответствует итоговой сумме операций по возврату!'"),
					НомерОтчета);
				Сообщение.Сообщить();
				
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Попытка
		
		Если НЕ ЗначениеЗаполнено(ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Дата) Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='При загрузке элемента ""Отчет"" №%1 в документе ""Отчет банка по операциям эквайринга"" не заполнена дата операции по платежной карте. Документ не создан!'"),
				НомерОтчета);
			Сообщение.Сообщить();
			
			Возврат;
			
		ИначеЕсли ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Покупки.Количество()
				+ ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Возвраты.Количество() = 0 Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='При загрузке элемента ""Отчет"" №%1 в документе ""Отчет банка по операциям эквайринга"" не заполнены платежи. Документ не создан!'"),
				НомерОтчета);
			Сообщение.Сообщить();
			
			Возврат;
			
		КонецЕсли;
		
		Если НЕ СуммаКомиссии = 0 Тогда
			ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.СуммаКомиссии     = СуммаКомиссии;
			ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.СтатьяРасходов    = СтатьяРасходов;
			ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.АналитикаРасходов = АналитикаРасходов;
			ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Подразделение     = Подразделение;
		КонецЕсли;
		
		ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Записать(РежимЗаписиДок);
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 документ ""Отчет банка по операциям эквайринга"" №%2 от %3.'"),
			?(РежимЗаписиДок = РежимЗаписиДокумента.Запись, "Записан", "Проведен"),
			ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Номер,
			ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Дата);
		Сообщение.Сообщить();
		
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Документ ""Отчет банка по операциям эквайринга"" №%1 от %2 не %3! Произошли ошибки при %4!'"),
			ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Номер,
			ОбъектДокументаОтчетБанкаПоОперациямЭквайринга.Дата,
			?(РежимЗаписиДок = РежимЗаписиДокумента.Запись, "записан", "проведен"),
			?(РежимЗаписиДок = РежимЗаписиДокумента.Запись, "записи", "проведении"));
		Сообщение.Сообщить();
		
	КонецПопытки
	
КонецПроцедуры

Процедура ЗагрузитьXMLФайлИзДереваЗначенийВИнформационнуюБазу(Элементы, ПроводитьДокументыПриЗагрузке, СтатьяРасходов, АналитикаРасходов, Подразделение)
	
	НомерОтчета = 0;
	
	АтрибутыЭлементаДанныеПоЗапросу = Новый Структура;
	
	Для Каждого Элемент Из Элементы Цикл
		
		Если Элемент.ИмяЭлемента = "РезультатЗапроса" Тогда	
			
			Если Элемент.ЗначениеЭлемента = "ошибкаЗапроса" Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru='Ошибка в запросе на предоставление отчета по операциям эквайринга. Отчет не загружен!'"));
				
			ИначеЕсли Элемент.ЗначениеЭлемента = "данныеОтсутствуют" Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru='В отчете по операциям эквайринга отсутствуют данные. Отчет не загружен!'"));
				
			Иначе
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru='В отчете по операциям эквайринга некорректное значение элемента ""РезультатЗапроса"". Отчет не загружен!'"));
				
			КонецЕсли;
			
			Возврат;
			
		ИначеЕсли Элемент.ИмяЭлемента = "СтрокаПоМерчанту" Тогда
			
			НомерОтчета = НомерОтчета + 1;
			
			Если Элемент.Строки.Найти("Дата", "ИмяЭлемента") = Неопределено Тогда
				
				ДатаПлатежногоПоручения = "";
				
				Если АтрибутыЭлементаДанныеПоЗапросу.Свойство("ДатаПлатежногоПоручения", ДатаПлатежногоПоручения) Тогда
					
					Если ЗначениеЗаполнено(ДатаПлатежногоПоручения) Тогда
						
						СтрДереваЗначений = Элемент.Строки.Добавить();
						СтрДереваЗначений.ИмяЭлемента = "Дата";
						СтрДереваЗначений.ЗначениеЭлемента = ДатаПлатежногоПоручения;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			МассивСтрокПоТерминалу = Элемент.Строки.НайтиСтроки(Новый Структура("ИмяЭлемента", "СтрокаПоТерминалу"));
			
			Для Каждого СтрокаПоТерминалу Из МассивСтрокПоТерминалу Цикл
				
				Если СтрокаПоТерминалу.Строки.Найти("ТипОперации", "ИмяЭлемента") = Неопределено Тогда
					
					Если АтрибутыЭлементаДанныеПоЗапросу.Свойство("ДатаПлатежногоПоручения") Тогда
						
						СтрДереваЗначений = СтрокаПоТерминалу.Строки.Добавить();
						СтрДереваЗначений.ИмяЭлемента = "ТипОперации";
						СтрДереваЗначений.ЗначениеЭлемента = "оплата";
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
			СоздатьДокументОтчетБанкаПоОперациямЭквайринга(Элемент.Строки, НомерОтчета, ПроводитьДокументыПриЗагрузке, СтатьяРасходов, АналитикаРасходов, Подразделение, АтрибутыЭлементаДанныеПоЗапросу);
			
		ИначеЕсли Элемент.ИмяЭлемента = "НаименованиеОрганизации"
			  ИЛИ Элемент.ИмяЭлемента = "ИНН"
			  ИЛИ Элемент.ИмяЭлемента = "БИК"
			  ИЛИ Элемент.ИмяЭлемента = "РасчетныйСчетОрганизации"
			  ИЛИ Элемент.ИмяЭлемента = "ДатаПлатежногоПоручения" Тогда
			  
			АтрибутыЭлементаДанныеПоЗапросу.Вставить(Элемент.ИмяЭлемента, Элемент.ЗначениеЭлемента);
			
		ИначеЕсли Элемент.Строки.Количество() > 0 Тогда
			
			ЗагрузитьXMLФайлИзДереваЗначенийВИнформационнуюБазу(Элемент.Строки, ПроводитьДокументыПриЗагрузке, СтатьяРасходов, АналитикаРасходов, Подразделение);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПрочитатьXMLФайлВДеревоЗначений(Объект, XMLФайл, ДеревоЗначенийXMLФайл, Адрес)
	
	ДеревоЗначенийXMLФайл.Строки.Очистить();
	
	ВремФайл = ПолучитьИмяВременногоФайла();
	
	ПолучитьИзВременногоХранилища(Адрес).Записать(ВремФайл);
	
	ФайлXML = Новый ЧтениеXML;
	
	ФайлXML.ОткрытьФайл(ВремФайл);
	
	Родитель = Неопределено;
	
	Попытка
		
		Пока ФайлXML.Прочитать() Цикл
			
			Если ФайлXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				Если Родитель = Неопределено Тогда
					ЭлементДереваЗначенийXMLФайл = ДеревоЗначенийXMLФайл.Строки.Добавить();
				Иначе
					ЭлементДереваЗначенийXMLФайл = Родитель.Строки.Добавить();
				КонецЕсли;
				
				ЭлементДереваЗначенийXMLФайл.ИмяЭлемента = ФайлXML.Имя;
				
				Родитель = ЭлементДереваЗначенийXMLФайл;
				
			ИначеЕсли ФайлXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда	
				
				Если НЕ Родитель = Неопределено Тогда
					Родитель = Родитель.Родитель;
				КонецЕсли;
				
			ИначеЕсли ФайлXML.ТипУзла = ТипУзлаXML.Текст Тогда		
				
				ЭлементДереваЗначенийXMLФайл.ЗначениеЭлемента = ФайлXML.Значение;
				
			КонецЕсли;
			
			Если ФайлXML.КоличествоАтрибутов() > 0 Тогда
				
				Пока ФайлXML.ПрочитатьАтрибут() Цикл
					
					ЭлементДереваЗначенийXMLФайлАтрибут = ЭлементДереваЗначенийXMLФайл.Строки.Добавить();
					ЭлементДереваЗначенийXMLФайлАтрибут.ИмяЭлемента      = ФайлXML.Имя;
					ЭлементДереваЗначенийXMLФайлАтрибут.ЗначениеЭлемента = ФайлXML.Значение;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Исключение
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Выбран файл с данными не в формате XML!'"), , "XMLФайл");
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли